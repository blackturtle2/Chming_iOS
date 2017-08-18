//
//  JSRegisterViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 16..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Alamofire
import Toaster
import SwiftyJSON

class JSRegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var textFieldPasswordConfirm: UITextField!
    @IBOutlet var textFieldUserName: UITextField!
    @IBOutlet var segmentGender: UISegmentedControl!
    
    @IBOutlet var uiViewTouchHideKeyboard: UIView!
    
    
    @IBAction func tabToHideKeyboard(_ sender: UITapGestureRecognizer) {
        textFieldEmail.resignFirstResponder()
        textFieldUserName.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        textFieldPasswordConfirm.resignFirstResponder()
        textFieldUserName.resignFirstResponder()
    }
    
    var checkEmailValidate: Bool = false
    
    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldEmail.delegate = self
        textFieldUserName.delegate = self
        textFieldPassword.delegate = self
        textFieldPasswordConfirm.delegate = self
        textFieldUserName.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*******************************************/
    // MARK: -  Logic                          //
    /*******************************************/
    
    // MARK: 이메일 중복체크 버튼 액션 정의.
    @IBAction func buttonEmailIsvalidAction(_ sender: UIButton) {
        
        if textFieldEmail.text == "" {
            Toast(text: "이메일을 입력해주세요.").show()
            return
        }
        
        let param: [String:String] = ["email" : textFieldEmail.text!]
        
        Alamofire.request(rootDomain + "/api/user/validate_email/", method: .get, parameters: param, headers: nil).responseJSON { [unowned self] (response) in
            
            switch response.result {
            case .success(let value):
                print("///// res: ", response.result.value ?? "no data" )  // { "is_valid" : 1; }
                
                let json = JSON(value) // { "is_valid" : true }
                let result = json["is_valid"].stringValue // true
                
                if result == "true" {
                    Toast(text: "사용 가능한 이메일입니다.").show()
                    self.checkEmailValidate = true
                    self.textFieldEmail.endEditing(true)
                }else {
                    Toast(text: "사용 불가능한 이메일입니다.\n다른 이메일 주소를 입력해주세요.").show()
                }
                
            case .failure(let err):
                print("///// error: ", err)
            }
        }
    }
    
    
    @IBAction func buttonProfileImage(_ sender: UIButton) {
        
    }
    
    
    @IBAction func buttonBirthAction(_ sender: UIButton) {
        
    }
    
    
    @IBAction func buttonLocationAction(_ sender: UIButton) {
        
    }
    
    
    @IBAction func buttonHobbyAction(_ sender: UIButton) {
        
    }
    
    
    @IBAction func buttonCompleteAction(_ sender: UIButton) {
        if textFieldEmail.text == "" {
            Toast(text: "이메일을 입력해주세요.").show()
            return
        } else if self.checkEmailValidate == false {
            Toast(text: "이메일 중복 체크가 먼저 필요합니다.").show()
            return
        } else if self.textFieldPassword.text == "" {
            Toast(text: "비밀번호를 입력해주세요.").show()
            return
        } else if self.textFieldPassword.text != self.textFieldPasswordConfirm.text {
            Toast(text: "비밀번호 확인이 틀렸습니다.\n비밀번호를 다시 확인해주세요.").show()
            return
        } else if textFieldUserName.text == "" {
            Toast(text: "이름을 입력해주세요.").show()
            return
        }
        
        let paramTest: [String:Any] = ["email" : "t_jaesung2@gmail.com",
                                      "password" : "123456",
                                      "confirm_password" : "123456",
                                      "username" : "테스트재성",
                                      "profile_img" : "",
                                      "gender" : "m",
                                      "birth_year" : 1988,
                                      "birth_month" : 10,
                                      "birth_day" : 19,
                                      "hobby" : "축구",
                                      "address" : "대한민국 서울특별시 영등포구 여의도동",
                                      "lat" : 37.5285730,
                                      "lng" : 126.9289740 ]
        
        guard let userEmail = textFieldEmail.text else { return }
        guard let userPassword = textFieldPassword.text else { return }
        guard let userName = textFieldUserName.text else { return }
        let userGender: String!
        switch segmentGender.selectedSegmentIndex {
        case 0:
            userGender = "m"
        case 1:
            userGender = "f"
        default:
            userGender = "m"
        }
        
        let param: [String:Any] = ["email" : userEmail,
                                   "password" : userPassword,
                                   "confirm_password" : userPassword,
                                   "username" : userName,
                                   "profile_img" : "",
                                   "gender" : userGender,
                                   "birth_year" : 1988,
                                   "birth_month" : 10,
                                   "birth_day" : 19,
                                   "hobby" : "축구",
                                   "address" : "대한민국 서울특별시 영등포구 여의도동",
                                   "lat" : 37.5285730,
                                   "lng" : 126.9289740 ]
        
        
        Alamofire.request(rootDomain + "/api/user/signup/", method: .post, parameters: param, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print("///// response: ", response.result.value ?? "no data" )
                print("///// value: ", value)
                
                let json = JSON(value)
                
                let usernameIssue = json["username"][0].stringValue
                print("///// usernameIssue: ", usernameIssue)
                if usernameIssue == "user with this username already exists." {
                    Toast(text: "중복되는 회원 이름입니다.\n이름을 다시 입력해주세요.").show()
                    return
                }
                
                let result = json["pk"].stringValue
                
                print("///// result: ", result)
                
            case .failure(let err):
                print("///// error: ", err)
            }
        }
    }
    
    
}
