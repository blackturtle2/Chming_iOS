//
//  CHMainViewController.swift
//  Chming_iOS
//
//  Created by CLEE on 01/08/2017.
//  Copyright © 2017 leejaesung. All rights reserved.
//

import UIKit
import Firebase

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
        
        signInOutlet.shapesForSignIn()
        
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
    
}
