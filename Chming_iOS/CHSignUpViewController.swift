//
//  CHSignUpViewController.swift
//  Chming_iOS
//
//  Created by CLEE on 07/08/2017.
//  Copyright © 2017 leejaesung. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import Toaster
import SwiftyJSON
import Alamofire

class CHSignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: IB Components////////////
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var backGroundImg: UIImageView!
    
    @IBOutlet var photoBtn: UIButton!
    @IBOutlet var emailTextField: UITextField!
    
    //이메일 체크 버튼을 레이블로 대체.
    @IBOutlet var emailValidationOutlet: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordCheckTextField: UITextField!
    
    @IBOutlet var genderSegment: UISegmentedControl!
    @IBOutlet var registerBirthDayBtn: UIButton!
    @IBOutlet var registerLocationBtn: UIButton!
    @IBOutlet var registerFavoriteBtn: UIButton!
    
    @IBOutlet var signUpOutlet: UIButton!
    
    
    // 성별 선택하기 Segment.
    // 디자인파트는 성능 테스트 후 삭제를 할 수 있음.
    @IBAction func genderSegmentAction(_ sender: UISegmentedControl) {
        
        let segAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        let btnBundles = [registerBirthDayBtn, registerFavoriteBtn, registerLocationBtn]
        
        switch genderSegment.selectedSegmentIndex {
        case 0:
            
            genderSegment.tintColor = #colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 0.5)
            genderSegment.layer.borderColor = #colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 0.5).cgColor
            genderSegment.setTitleTextAttributes(segAttributes as [NSObject : AnyObject], for: UIControlState.selected)
            
            photoBtn.setTitleColor(#colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 0.5), for: .normal)
            photoBtn.layer.borderColor = #colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 0.5).cgColor
            
            for btn in btnBundles {
                btn?.tintColor = #colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 0.5)
                btn?.layer.borderColor = #colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 0.5).cgColor
                btn?.setTitleColor(#colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 1), for: .normal)
            }
            
            print("남자")
            
        case 1:
            genderSegment.tintColor = #colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.5)
            genderSegment.layer.borderColor = #colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.5).cgColor
            genderSegment.setTitleTextAttributes(segAttributes as [NSObject : AnyObject], for: UIControlState.selected)
            
            photoBtn.setTitleColor(#colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.5), for: .normal)
            photoBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.5).cgColor
            
            for btn in btnBundles {
                btn?.tintColor = #colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.5)
                btn?.layer.borderColor = #colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.5).cgColor
                btn?.setTitleColor(#colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1), for: .normal)
            }
            
            print("여자")
            
        default:
            break
            
        }
        
        
    }
    
    // 생년월일 선택하기 DayPicker.
    @IBAction func birthDayPickerAction(_ sender: UIButton) {
        
    }
    
    
    
    // 회원가입 진행 버튼.
    @IBAction func registerAccount(sender:UIButton) {
        signUp()
    }
    
    // 프로필 이미지 등록
    @IBAction func photoActionButton(sender:UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    // 화면 터치시 키보드 내림
    @IBAction func guestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // 취소버튼. Token 유무에 따라 SignInView 또는 UserInfoView로 보냄.
    @IBAction func cancelButtonAction(sender: UIBarButtonItem) {
        
        // 분기처리는 나중에 애드.
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: App Cycle////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        //        nameTextField.becomeFirstResponder()
        
        
        nameTextField.shapesForSignUp()
        emailTextField.shapesForSignUp()
        //        emailTextField.roundedButton(corners: [.topLeft, .bottomLeft], radius: emailTextField.frame.height / 2)
        passwordTextField.shapesForSignUp()
        passwordCheckTextField.shapesForSignUp()
        genderSegment.shapesCustomizing()
        photoBtn.shapesForSignUpProfileImg()
        
        registerBirthDayBtn.shapesForRegisterBtnAtSignUp()
        registerLocationBtn.shapesForRegisterBtnAtSignUp()
        registerFavoriteBtn.shapesForRegisterBtnAtSignUp()
        
        signUpOutlet.applyGradient(withColours: [#colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.7),#colorLiteral(red: 1, green: 0.667937696, blue: 0.4736554623, alpha: 0.7)], gradientOrientation: .horizontal)
        signUpOutlet.cornerRadius()
        
        print(genderSegment.selectedSegmentIndex)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Methods//////////////////
    // 추후에 DataCenter에 넣어야 할 회원가입 메소드.
    func signUp() {
        
        // Validate the input
        guard let name = nameTextField.text, name != "",
            let emailAddress = emailTextField.text, emailAddress != "",
            let password = passwordTextField.text, password != "",
            let passwordCheck = passwordCheckTextField.text, password == passwordCheck else {
                
                let alertController = UIAlertController(title: "가입 오류", message: "정보를 확인 후 다시 입력 해주세요.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title:"OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                present(alertController, animated: true, completion: nil)
                
                return
        }
        
        // Register the user account on Firebase
        Auth.auth().createUser(withEmail: emailAddress, password: password, completion: { (user, error) in
            
            if let error = error {
                let alertController = UIAlertController(title: "가입 오류", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: { (error) in
                    
                    if let error = error {
                        print("Failed to change the display name: \(error.localizedDescription)")
                    }
                })
            }
            
            // Dismiss keyboard
            self.view.endEditing(true)
            
            // show
            //            self.navigationController?.pushViewController(CHSignUpRegionViewController, animated: true)
            //
        })
        
        //스토리지 데이터베이스 시작!
    }
    
    
    // 이미지 피커!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("info: ",info) // UIImagePickerControllerOriginalImage를 사용하는 것으로 파악.
        
        //        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else { return }
        guard let image = info["UIImagePickerControllerEditedImage"] as? UIImage else { return }
        
        //        photoBtn.setImage(image, for: .normal)
        photoBtn.setBackgroundImage(image, for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // 뷰 올리기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 100.0), animated:true)
    }
    
    // 뷰 내리기
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        
        if textField == emailTextField {
            emailValidationCheck()
        }
        
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
        
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordCheckTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            //signUp()
        }
        
        return true
        
    }
    
    
    
    func emailValidationCheck() {
        
        if emailTextField.text == "" {
            emailValidationOutlet.text = "이메일을 입력해주세요."
            emailValidationOutlet.textColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            
            return
        }
        
        let param: [String:String] = ["email" : emailValidationOutlet.text!]
        
        
        Alamofire.request(rootDomain + "/api/user/validate_email/", method: .get, parameters: param, headers: nil).responseJSON { [unowned self] (response) in
            
            switch response.result {
            case .success(let value):
                print("///// res: ", response.result.value ?? "no data" )  // { "is_valid" : 1; }
                
                let json = JSON(value) // { "is_valid" : true }
                let result = json["is_valid"].stringValue // true
                
                if self.checkEmailFormat(enteredEmail: self.emailTextField.text!) {
                    if result == "true" {
                        self.emailValidationOutlet.text = "사용 가능한 이메일입니다."
                        //                    Toast(text: "사용 가능한 이메일입니다.").show()
                        //                    self.checkEmailValidate = true
                        self.emailTextField.endEditing(true)
                    }else {
                        self.emailValidationOutlet.text = "사용 불가능한 이메일입니다. 다른 이메일 주소를 입력해주세요."
                        //                    Toast(text: "사용 불가능한 이메일입니다.\n다른 이메일 주소를 입력해주세요.").show()
                        
                        // 사용불가 판정시 리스폰더 재위치
                        self.emailTextField.becomeFirstResponder()
                    }
                } else {
                    self.emailValidationOutlet.text = "사용 불가능한 이메일입니다. 양식에 맞게 입력해주세요."
                    
                    // 사용불가 판정시 리스폰더 재위치
                    self.emailTextField.becomeFirstResponder()
                }
                
                
            case .failure(let err):
                print("///// error: ", err)
            }
        }
        
    }
    
    
    // 이메일 양식 정규표현식
    func checkEmailFormat(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    
    
    
    
}
