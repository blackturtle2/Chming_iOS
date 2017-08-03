//
//  LoginTestViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 2..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Firebase

class JSLoginTestViewController: UIViewController {
    
    @IBOutlet var labelTest:UILabel!

    var number:Int = 0

    
    // MARK: viewDidLoad() //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("GroupListMap").child("강남구").child("groupList").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let rootData = snapshot.value as! [String:Any]
            
            print("///// rootData: ",rootData)
            let myData = rootData["축구"]

            print("///// myData: ", myData ?? "(no data)")
            self.labelTest.text = "\(myData ?? "(no data)")"
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: login start //
    @IBAction func btnSignUpTest(_ sender:UIButton) {
        let tempMember = Member(pkUser: number, email: "blackturtle2@gmail.com", password: "123456", name: "Leejaesung", gender: .man, birthYear: 1988, birthMonth: 10, birthDay: 19, address: "인천시 계양구 작전1동", profileImageUrl: "http://www.google.com", interest: .축구)
        let signUpOkay = DataCenter.sharedInstance.signUpWith(member: tempMember)
        
        number = number + 1
        print("/////number: ", number)
        print(signUpOkay)
        
    }
    
    @IBAction func btnSignInTest(_ sender:UIButton) {
        let signInOkay = DataCenter.sharedInstance.signInWith(memberEmail: "chming@gmail.com", memberPassword: "123456")
        
        print(signInOkay)
    }
}