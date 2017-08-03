//
//  JSTabbarTestViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 3..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSTabbarTestViewController: UIViewController, UITabBarControllerDelegate {

    @IBOutlet var myUITabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let item1 = JSItem1ViewController()
        
//        self.viewControllers = [item1]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        
//        print("///// item.tag: ", item.tag)
//    }
    
    

}
