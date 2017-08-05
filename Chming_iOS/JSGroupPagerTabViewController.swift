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


class JSGroupPagerTabViewController: ButtonBarPagerTabStripViewController, JSGroupBoardMenuDelegate {
    var groupPK:Int? = nil // 이전 뷰에서 넘어오는 groupPK 입니다.
    
    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // XLPagerTabStrip의 탭바 설정입니다.
        // [주의!] 스토리보드의 설정들은 먹히지 않습니다.
        let mySelectedColor = UIColor(red: 242/255, green: 40/255, blue: 46/255, alpha: 1)
        let myBackgroundColor = UIColor(red: 64/255, green: 64/255, blue: 75/255, alpha: 1)
        buttonBarView.selectedBar.backgroundColor = mySelectedColor
        buttonBarView.backgroundColor = myBackgroundColor
        settings.style.buttonBarItemBackgroundColor = myBackgroundColor
        
        
        self.navigationItem.title = "OO 모임"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /***************************************************/
    // MARK: -  Add ViewControllers to XLPagerTabStrip //
    /***************************************************/
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: JSStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "JSGroupMainViewController") as! JSGroupMainViewController
        child_1.groupPK = self.groupPK
        
        let child_2 = UIStoryboard(name: JSStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "JSGroupBoardViewController") as! JSGroupBoardViewController
        child_2.delegate = self
        
        let child_3 = UIStoryboard(name: JSStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "JSGroupGalleryViewController") as! JSGroupGalleryViewController
        
        return [child_1, child_2, child_3]
    }
    
    
    /*******************************************/
    // MARK: -  Close Button Action            //
    /*******************************************/
    
    @IBAction func buttonClose(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func showNavigationBarPostingButton() {
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "글 작성", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: <#T##UIImage?#>, style: <#T##UIBarButtonItemStyle#>, target: <#T##Any?#>, action: <#T##Selector?#>)
    }
    
    func disMissNavigationBarPostingButton() {
        self.navigationItem.rightBarButtonItem = nil
    }

}
