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

class JSRegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var scrollViewMain: UIScrollView!
    
    @IBOutlet var buttonProfileImage: UIButton!
    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet var buttonValidateEmail: UIButton!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var textFieldPasswordConfirm: UITextField!
    @IBOutlet var textFieldUserName: UITextField!
    @IBOutlet var segmentGender: UISegmentedControl!
    
    @IBOutlet var uiViewOfBirthDatePicker: UIView!
    @IBOutlet var datePickerBirth: UIDatePicker!
    @IBOutlet var pickerLocation: UIPickerView!
    @IBOutlet var pickerHobby: UIPickerView!

    @IBOutlet var buttonBirth: UIButton!
    @IBOutlet var buttonLocation: UIButton!
    @IBOutlet var buttonHobby: UIButton!
    
    @IBOutlet var buttonComplete: UIButton! // 회원가입 완료 버튼
    
    // 이메일 중복체크 눌렀는지 여부 확인.
    var checkEmailValidate: Bool = false
    
    // 생년월일 기록용.
    var dataDatePickerBirth: Date?
    var birthYear: String?
    var birthMonth: String?
    var birthDay: String?
    
    var selectedDataPickerLocation: String?
    var selectedDataPickerHobby: String?
    var tempDataPickerLocation: [String]?
    var tempDataPickerHobby: [String]?
    
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
        
        pickerLocation.delegate = self
        pickerLocation.dataSource = self
        pickerHobby.delegate = self
        pickerHobby.dataSource = self
        
        textFieldUserName.shapesForSignUp()
        textFieldEmail.roundedButton(corners: [.topLeft, .bottomLeft], radius: textFieldEmail.frame.height / 2)
        buttonValidateEmail.roundedButton(corners: [.topRight, .bottomRight], radius: buttonValidateEmail.frame.height / 2)
        textFieldPassword.shapesForSignUp()
        textFieldPasswordConfirm.shapesForSignUp()
        segmentGender.shapesCustomizing()
        buttonProfileImage.shapesForSignUpProfileImg()
        
        buttonBirth.shapesForRegisterBtnAtSignUp()
        buttonLocation.shapesForRegisterBtnAtSignUp()
        buttonHobby.shapesForRegisterBtnAtSignUp()
        
        buttonComplete.applyGradient(withColours: [#colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.7),#colorLiteral(red: 1, green: 0.667937696, blue: 0.4736554623, alpha: 0.7)], gradientOrientation: .horizontal)
        buttonComplete.cornerRadius()
        
        print(segmentGender.selectedSegmentIndex)
        
        self.tempDataPickerLocation = ["종로", "강남", "신림", "용산", "건대"]
        self.tempDataPickerHobby = ["축구", "야구", "농구", "탁구", "풋살"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Cancel 버튼 액션 정의.
    @IBAction func buttonCancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 화면의 남는 공간을 아무 곳이나 터치하면, 키보드 숨기기.
    @IBAction func tabToHideKeyboard(_ sender: UITapGestureRecognizer) {
        textFieldEmail.resignFirstResponder()
        textFieldUserName.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        textFieldPasswordConfirm.resignFirstResponder()
        textFieldUserName.resignFirstResponder()
    }
    
    
    // 뷰 올리기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollViewMain.setContentOffset(CGPoint(x: 0.0, y: 100.0), animated:true)
    }
    
    // 뷰 내리기
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollViewMain.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    // 리턴키 설정
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textFieldUserName {
            textFieldEmail.becomeFirstResponder()
        } else if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            textFieldPasswordConfirm.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
        
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
    
    @IBAction func segmentedControlGender(_ sender: UISegmentedControl) {
        let segAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        let btnBundles = [buttonBirth, buttonHobby, buttonLocation]
        
        switch segmentGender.selectedSegmentIndex {
        case 0:
            
            segmentGender.tintColor = #colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 0.5)
            segmentGender.layer.borderColor = #colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 0.5).cgColor
            segmentGender.setTitleTextAttributes(segAttributes as [NSObject : AnyObject], for: UIControlState.selected)
            
            buttonProfileImage.setTitleColor(#colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 0.5), for: .normal)
            buttonProfileImage.layer.borderColor = #colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 0.5).cgColor
            
            for btn in btnBundles {
                btn?.tintColor = #colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 0.5)
                btn?.layer.borderColor = #colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 0.5).cgColor
                btn?.setTitleColor(#colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 1), for: .normal)
            }
            
        case 1:
            segmentGender.tintColor = #colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.5)
            segmentGender.layer.borderColor = #colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.5).cgColor
            segmentGender.setTitleTextAttributes(segAttributes as [NSObject : AnyObject], for: UIControlState.selected)
            
            buttonProfileImage.setTitleColor(#colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.5), for: .normal)
            buttonProfileImage.layer.borderColor = #colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.5).cgColor
            
            for btn in btnBundles {
                btn?.tintColor = #colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.5)
                btn?.layer.borderColor = #colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.5).cgColor
                btn?.setTitleColor(#colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1), for: .normal)
            }
            
        default:
            break
            
        }
    }
    
    /***************************/
    // MARK: -  생년월일 Logic    //
    /***************************/
    
    var selectedPicker: enumSelectedPicker = .birth
    
    enum enumSelectedPicker:String {
        case birth
        case location
        case hobby
    }
    
    // 생년월일 버튼 액션 정의.
    @IBAction func buttonBirthAction(_ sender: UIButton) {
        self.selectedPicker = .birth
        self.uiViewOfBirthDatePicker.isHidden = false // DatePicker와 취소-확인 버튼까지 있는 UIView.
        self.datePickerBirth.isHidden = false
    }
    
    
    /***************************/
    // MARK: -  위치등록 Logic    //
    /***************************/
    
    @IBAction func buttonLocationAction(_ sender: UIButton) {
        self.selectedPicker = .location
        self.uiViewOfBirthDatePicker.isHidden = false
        self.pickerLocation.isHidden = false
    }
    
    
    /**************************/
    // MARK: -  관심사 Logic    //
    /**************************/
    
    @IBAction func buttonHobbyAction(_ sender: UIButton) {
        self.selectedPicker = .hobby
        self.uiViewOfBirthDatePicker.isHidden = false
        self.pickerHobby.isHidden = false
    }
    
    
    /*********************************/
    // MARK: -  Picker View Logic    //
    /*********************************/
    
    // datePicker 값 변화 트랙킹.
    @IBAction func datePickerBirthValueChanged(_ sender: UIDatePicker) {
        self.dataDatePickerBirth = sender.date
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerLocation {
            // 주소 피커
            return 5
        }else if pickerView == self.pickerHobby {
            // 관심사 피커
            return 5
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerLocation {
            // 주소 피커
            guard let result = self.tempDataPickerLocation?[row] else { return "(no data)" }
            return result
        }else if pickerView == self.pickerHobby {
            // 관심사 피커
            guard let result = self.tempDataPickerHobby?[row] else { return "(no data)" }
            return result
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerLocation {
            // 주소 피커
            self.selectedDataPickerLocation = self.tempDataPickerLocation?[row]
        }else if pickerView == self.pickerHobby {
            // 관심사 피커
            self.selectedDataPickerHobby = self.tempDataPickerHobby?[row]
        }
    }
    
    
    // Picker 확인 버튼 액션 정의.
    @IBAction func buttonBirthDatePickerConfirm(_ sender: UIButton) {
        
        switch self.selectedPicker {
        case .birth:
            let dateFormatter = DateFormatter()
            //        dateFormatter.dateStyle = DateFormatter.Style.medium
            //        dateFormatter.timeStyle = DateFormatter.Style.none
            //        // result --> 2017. 8. 19.
            
            guard let birthDate = self.dataDatePickerBirth else { return }
            dateFormatter.dateFormat = "yyyy"
            print("yyyy", dateFormatter.string(from: birthDate))
            self.birthYear = dateFormatter.string(from: birthDate)
            
            dateFormatter.dateFormat = "MM"
            print("MM", dateFormatter.string(from: birthDate))
            self.birthMonth = dateFormatter.string(from: birthDate)
            
            dateFormatter.dateFormat = "dd"
            print("dd", dateFormatter.string(from: birthDate))
            self.birthDay = dateFormatter.string(from: birthDate)
            
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            self.buttonBirth.setTitle("\(dateFormatter.string(from: birthDate))", for: .normal)
            
        case .location:
            self.buttonLocation.setTitle(self.selectedDataPickerLocation, for: .normal)
        case .hobby:
            self.buttonHobby.setTitle(self.selectedDataPickerHobby, for: .normal)
        }
        
        self.uiViewOfBirthDatePicker.isHidden = true
        self.datePickerBirth.isHidden = true
        self.pickerLocation.isHidden = true
        self.pickerHobby.isHidden = true
        
    }
    
    // Picker 취소 버튼 액션 정의.
    @IBAction func buttonBirthDatePickerCancel(_ sender: UIButton) {
        self.uiViewOfBirthDatePicker.isHidden = true
        self.datePickerBirth.isHidden = true
        self.pickerLocation.isHidden = true
        self.pickerHobby.isHidden = true
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
        guard let hobby = self.selectedDataPickerHobby else { return }
        guard let location = self.selectedDataPickerLocation else { return }
        
        let param: [String:Any] = ["email" : userEmail,
                                   "password" : userPassword,
                                   "confirm_password" : userPassword,
                                   "username" : userName,
                                   "profile_img" : "",
                                   "gender" : userGender,
                                   "birth_year" : birthYear,
                                   "birth_month" : birthMonth,
                                   "birth_day" : birthDay,
                                   "hobby" : hobby,
                                   "address" : location,
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
                self.dismiss(animated: true, completion: nil)
                print("///// resultPK: ", resultPK)
                
            case .failure(let err):
                print("///// error: ", err)
            }
        }
    }
    
    
}
