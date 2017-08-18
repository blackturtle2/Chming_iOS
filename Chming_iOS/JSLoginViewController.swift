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

class JSLoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    
    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
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
                    
                }else {
                    Toast(text: "로그인 실패입니다. \n이메일 혹은 비밀번호를 다시 확인해주세요.").show()
                }

                
            case .failure(let err):
                print("///// error: ", err)
            }
            
            
        }
        
    }

}
