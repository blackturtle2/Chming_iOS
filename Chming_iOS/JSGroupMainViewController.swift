//
//  JSGroupMainViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class JSGroupMainViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    var groupPK:Int? = nil // 이전 뷰에서 넘어오는 groupPK 입니다.
    
    @IBOutlet var mainTableView:UITableView!
    
    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
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
    
    // XLPagerTabStrip 에서 Tab 버튼에 Indicator 정보를 등록하는 Delegate 함수입니다.
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "모임 정보")
    }
    
    
    
    /*********************************************/
    // MARK: -  UITableView Delegate & DataSource//
    /*********************************************/
    
    // Section Number
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    // Row Number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Secion Title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 3:
            return "공지사항"
        case 4:
            return "회원목록"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return (self.view.frame.width/16*9)
        case 1:
            return 100
        case 2:
            return 100
        case 3:
            return 100
        case 4:
            return 100
        default:
            return 43.5
        }
    }
    
    // Custom Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "1stMainImageCell", for: indexPath)
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "2ndMainTextCell", for: indexPath)
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "3rdJoinLikeGroupCell", for: indexPath)
        case 3:
            return tableView.dequeueReusableCell(withIdentifier: "4thNoticeListCell", for: indexPath)
        case 4:
            return tableView.dequeueReusableCell(withIdentifier: "5thMemberListCell", for: indexPath)
        default:
            let basicCell = UITableViewCell()
            return basicCell
        }
    }
    
    
}
