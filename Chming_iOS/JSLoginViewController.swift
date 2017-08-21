//
//  JSLoginViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 16..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Alamofire
import Toaster
import SwiftyJSON
import AVFoundation

protocol loginCompleteDelegate {
    func completeLogin()
}

class JSLoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var buttonLogin: UIButton!
    @IBOutlet var scrollViewMain: UIScrollView!
    
    var loginDelegate: loginCompleteDelegate?
    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        
        textFieldEmail.shapesForSignIn()
        textFieldPassword.shapesForSignIn()
        
        buttonLogin.applyGradient(withColours: [#colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.7),#colorLiteral(red: 1, green: 0.667937696, blue: 0.4736554623, alpha: 0.7)], gradientOrientation: .horizontal)
        buttonLogin.cornerRadius()
        
        // background AV
        self.setupVideoBackground()
        videoURL = Bundle.main.url(forResource: "PolarBear", withExtension: "mov")! as NSURL
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*******************************************/
    // MARK: -  Logic                          //
    /*******************************************/
    
    // MARK: 임시로 만든 Close 버튼 액션 정의.
    @IBAction func buttonCloseAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: 로그인 버튼 액션 정의.
    @IBAction func buttonLoginAction(_ sender: UIButton) {
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        
        if textFieldEmail.text == "" {
            Toast(text: "이메일을 입력해주세요.").show()
            return
        }else if textFieldPassword.text == "" {
            Toast(text: "비밀번호를 입력해주세요.").show()
            return
        }
        
        guard let email = textFieldEmail.text else { return }
        guard let password = textFieldPassword.text else { return }
        
        let param: [String:String] = ["email" : email, "password" : password]
//        let param: [String:String] = ["email" : "t_jaesung1@gmail.com", "password" : "123456"]
        
        Alamofire.request(rootDomain + "/api/user/login/", method: .post, parameters: param, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print("///// res: ", response.result.value ?? "no data" )
                
                let json = JSON(value)
                print("///// json: ", json)
                
                let userToken = json["token"].stringValue
                let userPK = json["login_user_info"]["pk"].stringValue
                let userHobby = json["login_user_info"]["hobby"].arrayValue.map({ (json) -> String in
                    return json.stringValue
                })
                
                if userToken != "" {
                    UserDefaults.standard.set(userToken, forKey: userDefaultsToken) // Token을 UserDefaults에 저장.
                    UserDefaults.standard.set(userPK, forKey: userDefaultsPk) // UserPK를 UserDefaults에 저장.
                    UserDefaults.standard.set(userHobby, forKey: userDefaultsHobby) // UserHobby를 UserDefaults에 저장.
                    
                    // UserDefaults 정상 저장 확인 위한 print
                    print("///// UserDefaults Token: ", UserDefaults.standard.string(forKey: userDefaultsToken) ?? "no data")
                    print("///// UserDefaults PK: ", UserDefaults.standard.string(forKey: userDefaultsPk) ?? "no data")
                    print("///// UserDefaults Hobby: ", UserDefaults.standard.array(forKey: userDefaultsHobby) ?? "no data")
                    
                    Toast(text: "로그인 성공입니다.").show() // 로그인 성공 후, 뷰 이동 프로세스 작성 필요.
                    self.dismiss(animated: true, completion: {
                        self.loginDelegate?.completeLogin()
                    })
                    
                    
                }else {
                    Toast(text: "로그인 실패입니다. \n이메일 혹은 비밀번호를 다시 확인해주세요.").show()
                }

                
            case .failure(let err):
                print("///// error: ", err)
            }
            
            
        }
        
    }

    
    /*******************************************/
    // MARK: -  키보드 올라오는 것에 따르는 오토 스크롤  //
    /*******************************************/
    
    // 뷰 올리기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollViewMain.setContentOffset(CGPoint(x: 0.0, y: 130.0), animated:true)
    }
    
    // 뷰 내리기
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollViewMain.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    // 리턴키를 터치하면, 다음 텍스트필드로 넘어가거나 로그인 function을 타도록 세팅.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        } else {
            self.buttonLoginAction(buttonLogin)
        }
        
        return true
    }
    
    // 화면 다른 곳을 터치하면, 키보드 숨기기.
    @IBAction func tabHideKeyboard(_ sender: UITapGestureRecognizer) {
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
    }
    
    
    /****************************************/
    // MARK: -  백그라운드 동영상 재생 로직        //
    /****************************************/
    
    public var videoURL: NSURL? {
        didSet {
            setupVideoBackground()
        }
    }
    
    func setupVideoBackground() {
        var theURL = NSURL()
        if let url = videoURL {
            
            let shade = UIView(frame: self.view.frame)
            shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            view.addSubview(shade)
            view.sendSubview(toBack: shade)
            
            theURL = url
            
            var avPlayer = AVPlayer()
            avPlayer = AVPlayer(url: theURL as URL)
            let avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            avPlayer.volume = 0
            avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none
            
            avPlayerLayer.frame = view.layer.bounds
            
            let layer = UIView(frame: self.view.frame)
            view.backgroundColor = UIColor.clear
            view.layer.insertSublayer(avPlayerLayer, at: 0)
            view.addSubview(layer)
            view.sendSubview(toBack: layer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
            
            avPlayer.play()
        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        if let p = notification.object as? AVPlayerItem {
            p.seek(to: kCMTimeZero)
        }
    }
    
}
