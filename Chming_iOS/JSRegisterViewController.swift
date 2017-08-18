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

class JSRegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var buttonProfileImage: UIButton!
    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var textFieldPasswordConfirm: UITextField!
    @IBOutlet var textFieldUserName: UITextField!
    @IBOutlet var segmentGender: UISegmentedControl!
    
    @IBOutlet var uiViewTouchHideKeyboard: UIView!
    
    @IBOutlet var datePickerBirth: UIDatePicker!
    @IBOutlet var uiViewOfBirthDatePicker: UIView!

    // 화면의 남는 공간을 아무 곳이나 터치하면, 키보드 숨기기.
    @IBAction func tabToHideKeyboard(_ sender: UITapGestureRecognizer) {
        textFieldEmail.resignFirstResponder()
        textFieldUserName.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        textFieldPasswordConfirm.resignFirstResponder()
        textFieldUserName.resignFirstResponder()
    }
    
    // 이메일 중복체크 눌렀는지 여부 확인.
    var checkEmailValidate: Bool = false
    
    // 생년월일 기록용.
    var datePickerData: Date?
    var birthYear: String?
    var birthMonth: String?
    var birthDay: String?
    
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
    
    // MARK: -  프로필 이미지 Logic.
    @IBAction func buttonProfileImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // imagePickerController Delegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("///// info: ", info)
        guard let image = info["UIImagePickerControllerEditedImage"] as? UIImage else { return }
        self.buttonProfileImage.setBackgroundImage(image, for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }

    
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
    
    
    /***************************/
    // MARK: -  생년월일 Logic    //
    /***************************/
    
    // 생년월일 버튼 액션 정의.
    @IBAction func buttonBirthAction(_ sender: UIButton) {
//        self.datePickerBirth.backgroundColor = .white
        self.uiViewOfBirthDatePicker.isHidden = false // DatePicker와 취소-확인 버튼까지 있는 UIView.
    }
    
    // datePicker 값 변화 트랙킹.
    @IBAction func datePickerBirthValueChanged(_ sender: UIDatePicker) {
        
        self.datePickerData = sender.date
        
    }
    
    // DatePicker 확인 버튼 액션 정의.
    @IBAction func buttonBirthDatePickerConfirm(_ sender: UIButton) {
        
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateStyle = DateFormatter.Style.medium
        //        dateFormatter.timeStyle = DateFormatter.Style.none
        //        // result --> 2017. 8. 19.
        
        guard let birthDate = self.datePickerData else { return }
        dateFormatter.dateFormat = "yyyy"
        print("yyyy", dateFormatter.string(from: birthDate))
        self.birthYear = dateFormatter.string(from: birthDate)
        
        dateFormatter.dateFormat = "MM"
        print("MM", dateFormatter.string(from: birthDate))
        self.birthMonth = dateFormatter.string(from: birthDate)
        
        dateFormatter.dateFormat = "dd"
        print("dd", dateFormatter.string(from: birthDate))
        self.birthDay = dateFormatter.string(from: birthDate)
        
        self.uiViewOfBirthDatePicker.isHidden = true
    }
    
    // DatePicker 취소 버튼 액션 정의.
    @IBAction func buttonBirthDatePickerCancel(_ sender: UIButton) {
        self.uiViewOfBirthDatePicker.isHidden = true
    }
    
    
    
    /***************************/
    // MARK: -  위치등록 Logic    //
    /***************************/
    
    @IBAction func buttonLocationAction(_ sender: UIButton) {
        
    }
    
    
    /**************************/
    // MARK: -  관심사 Logic    //
    /**************************/
    
    @IBAction func buttonHobbyAction(_ sender: UIButton) {
        
    }
    
    
    /***************************/
    // MARK: -  완료 버튼 Logic   //
    /***************************/
    
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
        } else if self.birthYear == nil {
            Toast(text: "생년월일을 입력해주세요.").show()
            return
        }
        
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
        
        guard let birthYear = self.birthYear else { return }
        guard let birthMonth = self.birthMonth else { return }
        guard let birthDay = self.birthDay else { return }
        
        let param: [String:Any] = ["email" : userEmail,
                                   "password" : userPassword,
                                   "confirm_password" : userPassword,
                                   "username" : userName,
                                   "profile_img" : "",
                                   "gender" : userGender,
                                   "birth_year" : birthYear,
                                   "birth_month" : birthMonth,
                                   "birth_day" : birthDay,
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
                if usernameIssue == "user with this username already exists." {
                    print("///// usernameIssue: ", usernameIssue)
                    Toast(text: "중복되는 회원 이름입니다.\n이름을 다시 입력해주세요.").show()
                    return
                }
                
                let resultPK = json["pk"].stringValue
                Toast(text: "회원가입 되었습니다. :D").show()
                print("///// resultPK: ", resultPK)
                
            case .failure(let err):
                print("///// error: ", err)
            }
        }
    }
    
    
}
