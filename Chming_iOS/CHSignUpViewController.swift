//
//  CHSignUpViewController.swift
//  Chming_iOS
//
//  Created by CLEE on 07/08/2017.
//  Copyright © 2017 leejaesung. All rights reserved.
//

import UIKit
import Firebase

class CHSignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//MARK: IB Components////////////
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var backGroundImg: UIImageView!

    @IBOutlet var photoBtn: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordCheckTextField: UITextField!
    
    @IBOutlet var genderSegment: UISegmentedControl!
    @IBOutlet var birthDayPicker: UIDatePicker!
    
    // 성별 선택하기 Segment.
    @IBAction func genderSegmentAction(_ sender: UISegmentedControl) {
        
        switch genderSegment.selectedSegmentIndex {
        case 0:
            print("남자")
        case 1:
            print("여자")
        default:
            break
            
        }
    }
    
    // 생년월일 선택하기 DayPicker.
    @IBAction func birthDayPickerAction(_ sender: UIDatePicker) {
        
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
        
        self.title = "Sign Up"
        //        nameTextField.becomeFirstResponder()
        
        nameTextField.shapesForSignUp()
        emailTextField.shapesForSignUp()
        passwordTextField.shapesForSignUp()
        passwordCheckTextField.shapesForSignUp()
        genderSegment.shapesForSignUp()
        photoBtn.shapesForSignUpProfileImg()
        
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

    
}
