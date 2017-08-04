//
//  JSGroupMainViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class JSGroupMainViewController: UIViewController, IndicatorInfoProvider {
    
    var groupPK:Int? = nil // 이전 뷰에서 넘어오는 groupPK 입니다.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let vGroupPK = groupPK else {
            print("///// groupPK is no data-")
            
            let alertViewController = UIAlertController(title: "알림", message: "인터넷 연결이 불안정합니다. 잠시 후, 다시 시도해주세요.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "ok", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil) // 작동 불가?
            })
            alertViewController.addAction(alertAction)
            self.present(alertViewController, animated: true, completion: nil)
            
            return
        }
        
        print("///// groupPK: ", vGroupPK)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "모임 정보")
    }
    
    
}
