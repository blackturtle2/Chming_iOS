//
//  CHMainViewController.swift
//  Chming_iOS
//
//  Created by CLEE on 01/08/2017.
//  Copyright © 2017 leejaesung. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class CHSignInViewController: UIViewController, UITextFieldDelegate {

//MARK: IB Components////////////
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var backgroundImg: UIImageView!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    // 로그인 버튼
    @IBOutlet var signInOutlet: UIButton!
    @IBAction func signInAction(sender: UIButton) {
        signIn()
    }
    
    // Cancel 버튼 클릭시 SignInView 로 보내는 UnwindSegue
//    @IBAction func unwindToSignInView(segue: UIStoryboardSegue) {
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func gestureAction(_ sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    
//MARK: App Cycle////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.shapesForSignIn()
        passwordTextField.shapesForSignIn()
        
        signInOutlet.applyGradient(withColours: [#colorLiteral(red: 1, green: 0.1568113565, blue: 0.2567096651, alpha: 0.7),#colorLiteral(red: 1, green: 0.667937696, blue: 0.4736554623, alpha: 0.7)], gradientOrientation: .horizontal)
        signInOutlet.cornerRadius()
        
        // background AV
        self.setupVideoBackground()
        videoURL = Bundle.main.url(forResource: "PolarBear", withExtension: "mov")! as NSURL
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Sign In"
//        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.title = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//MARK: Methods//////////////////
    // 화면 터치시 키보드 내림
    //override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //
    //    self.view.endEditing(true)
    //
    //}
    
    // 뷰 올리기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 130.0), animated:true)
    }
    
    // 뷰 내리기
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    // 리턴키 설정
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //        switch textField.tag {
        //        case 101:
        //            passwordTextField.becomeFirstResponder()
        //        case 102:
        //            passwordTextField.resignFirstResponder()
        //        default:
        //            textField.resignFirstResponder()
        //        }
        //        return true
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            signIn()
        }
        
        return true
        
    }
    
    // 로그인 메소드. 추후에 DataCenter 에 옮겨놔야 함.
    func signIn() {
        // Validate the input
        guard let emailAddress = emailTextField.text, emailAddress != "",
            let password = passwordTextField.text, password != "" else {
                
                let alertController = UIAlertController(title: "로그인 애러", message: "빈칸을 채워주세요.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
        }
        
        // Perfom login by calling Firebase APIs
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (user, error) in
            
            if let error = error {
                let alertController = UIAlertController(title: "로그인 애러", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            // Dissmiss keyboard
            self.view.endEditing(true)
            
            // Present the main view
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
    
    // 하늘이형 제공.
    public var videoURL: NSURL? {
        didSet {
            setupVideoBackground()
        }
    }
    
    // 로그인 페이지 백그라운드 설정
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
