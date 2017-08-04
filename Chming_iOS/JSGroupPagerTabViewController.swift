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
    
    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mySelectedColor = UIColor(red: 242/255, green: 40/255, blue: 46/255, alpha: 1)
        let myBackgroundColor = UIColor(red: 64/255, green: 64/255, blue: 75/255, alpha: 1)
        buttonBarView.selectedBar.backgroundColor = mySelectedColor
        buttonBarView.backgroundColor = myBackgroundColor
        settings.style.buttonBarItemBackgroundColor = myBackgroundColor
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "menu", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = "OO 모임"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /***************************************************/
    // MARK: -  Add ViewControllers to XLPagerTabStrip //
    /***************************************************/
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: JSStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "JSGroupMainViewController") as! JSGroupMainViewController
        child_1.groupPK = self.groupPK
        
        let child_2 = UIStoryboard(name: JSStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "JSGroupBoardViewController")
        
        let child_3 = UIStoryboard(name: JSStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "JSGroupGalleryViewController")
        
        return [child_1, child_2, child_3]
    }
    
    
    /*******************************************/
    // MARK: -  Close Button Action            //
    /*******************************************/
    
    @IBAction func buttonClose(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }

}
