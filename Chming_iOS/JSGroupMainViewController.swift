//
//  JSGroupMainViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSGroupMainViewController: UIViewController {
    
    var number:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnSignUpTest(_ sender:UIButton) {
        let tempMember = LightMember(pkUser: number, email: "jaesung@gmail.com", password: "123456")
        let signUpOkay = DataCenter.sharedInstance.signUpWith(member: tempMember)
        
        number = number + 1
        print("/////number: ", number)
        print(signUpOkay)
    }

}
