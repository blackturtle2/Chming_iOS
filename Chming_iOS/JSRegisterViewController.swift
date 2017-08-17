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

class JSRegisterViewController: UIViewController {
    
    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var textFieldPasswordConfirm: UITextField!
    @IBOutlet var textFieldUserName: UITextField!
    
    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        Alamofire.request("http://chming.jeongmyeonghyeon.com/api/user/validate_email/", method: .get, parameters: param, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print("///// res: ", response.result.value ?? "no data" )  // { "is_valid" : 1; }
                
                let json = JSON(value) // { "is_valid" : true }
                let result = json["is_valid"].stringValue // true
                
                if result == "true" {
                    Toast(text: "사용 가능한 이메일입니다.").show()
                }else {
                    Toast(text: "사용 불가능한 이메일입니다.\n다른 이메일 주소를 입력해주세요.").show()
                }
                
            case .failure(let err):
                print("///// error: ", err)
            }
        }
    }}
