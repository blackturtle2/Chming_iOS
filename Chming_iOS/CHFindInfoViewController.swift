//
//  CHPwFindViewController.swift
//  Chming_iOS
//
//  Created by CLEE on 09/08/2017.
//  Copyright © 2017 leejaesung. All rights reserved.
//

import UIKit
import Firebase

class CHFindInfoViewController: UIViewController {
    
    //변수 만들어서 ValueKey:Int?
    
    // UIBarButton 취소 액션 -> SignInView
    @IBAction func cancelAction(sender: UIBarButtonItem) {
    
        self.dismiss(animated: true, completion: nil)
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
