//
//  LoginTestViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 2..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSLoginTestViewController: UIViewController {

    var number:Int = 0

    
    // MARK: viewDidLoad() //
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: login start //
    @IBAction func btnSignUpTest(_ sender:UIButton) {
        let tempMember = Member(pkUser: number, email: "blackturtle2@gmail.com", password: "123456", name: "Leejaesung", gender: .man, birthYear: 1988, birthMonth: 10, birthDay: 19, address: "인천시 계양구 작전1동", profileImageUrl: "http://www.google.com")
        let signUpOkay = DataCenter.sharedInstance.signUpWith(member: tempMember)
        
        number = number + 1
        print("/////number: ", number)
        print(signUpOkay)
    }
    
    @IBAction func btnSignInTest(_ sender:UIButton) {
        let signInOkay = DataCenter.sharedInstance.signInWith(memberEmail: "blackturtle2@gmail.com", memberPassword: "123456")
        
        print(signInOkay)
    }
}
