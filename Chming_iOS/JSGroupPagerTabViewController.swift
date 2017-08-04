//
//  JSGroupPagerTabViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import XLPagerTabStrip

let JSStoryboardName = "JSGroupMain"


class JSGroupPagerTabViewController: ButtonBarPagerTabStripViewController {
    var groupPK:Int? = nil // 이전 뷰에서 넘어오는 groupPK 입니다.

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonBarView.selectedBar.backgroundColor = .orange
        buttonBarView.backgroundColor = UIColor(red: 7/255, green: 185/255, blue: 155/255, alpha: 1)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "hihihi", style: .plain, target: nil, action: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: JSStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "JSGroupMainViewController") as! JSGroupMainViewController
        child_1.groupPK = self.groupPK
        
        let child_2 = UIStoryboard(name: JSStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "JSGroupBoardViewController")
        
        let child_3 = UIStoryboard(name: JSStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "JSGroupGalleryViewController")
        
        return [child_1, child_2, child_3]
    }
    
    
    @IBAction func buttonClose(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }

}
