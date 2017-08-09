//
//  CHSignUpViewController.swift
//  Chming_iOS
//
//  Created by CLEE on 07/08/2017.
//  Copyright © 2017 leejaesung. All rights reserved.
//

import UIKit
import Firebase

class CHSignUpViewController: UIViewController {
   
    @IBOutlet var backGroundImg: UIImageView!
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordCheckTextField: UITextField!
    
    @IBOutlet var genderSegment: UISegmentedControl!
    
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
    
    @IBOutlet var birthDayPicker: UIDatePicker!
    @IBAction func birthDayPickerAction(_ sender: UIDatePicker) {
        print(birthDayPickerAction(sender))
    }
    
    @IBAction func registerAccount(sender:UIButton) {
        
        // Validate the input
        guard let name = nameTextField.text, name != "",
            let emailAddress = emailTextField.text, emailAddress != "",
            let password = passwordTextField.text, password != "",
            let checkPassword = passwordCheckTextField.text, password != checkPassword else {
                
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
    }



    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sign Up"
        nameTextField.becomeFirstResponder()
        
        print(genderSegment.selectedSegmentIndex)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//enum Gender: Int {
//    
//    case noSelected = 0
//    case man = 1
//    case woman = 2
//}
