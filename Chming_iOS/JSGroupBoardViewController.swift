//
//  JSGroupBoardViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class JSGroupBoardViewController: UIViewController, IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "hello", style: .plain, target: nil, action: nil)
        
        
//        self.parent?.navigationItem.setRightBarButton(UIBarButtonItem(title: "hello", style: .plain, target: nil, action: nil), animated: true)
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "게시판")
    }
    
    
    @IBAction func btnTest(_ sender:UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "JSGroupBoardDetailViewController") as! JSGroupBoardDetailViewController
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
