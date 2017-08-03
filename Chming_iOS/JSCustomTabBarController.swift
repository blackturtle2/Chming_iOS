//
//  JSCustomTabBarController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 3..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSCustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.frame = CGRect(origin: CGPoint(x: 0, y :64), size: CGSize(width: self.view.frame.width, height: 50))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
