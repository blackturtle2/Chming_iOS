//
//  JSGroupBoardPostingViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 5..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSGroupBoardPostingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*******************************************/
    // MARK: -  Close Button Action            //
    /*******************************************/
    
    @IBAction func buttonClose(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }

}
