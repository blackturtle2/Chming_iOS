//
//  JSCreateGroupViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSCreateGroupViewController: UIViewController {
    
    var userPK:Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        print("///// userPK: ", userPK ?? "(no data)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClose(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }

}
