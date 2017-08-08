//
//  JSGroupInfoViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class JSGroupInfoViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
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
        
        // groupPK 값이 오지 않았을 케이스 예외처리
        guard let vGroupPK = groupPK else {
            print("///// groupPK is no data-")
            
            let alertViewController = UIAlertController(title: "알림", message: "인터넷 연결이 불안정합니다. 잠시 후, 다시 시도해주세요.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "ok", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
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
    // 모임 메인 화면의 섹션은 총 5개로 고정합니다.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    // Row Number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Cell's custom height
    // 각 Cell의 AutoLayout을 Bottom까지 잘 설정한 후, UITableViewAutomaticDimension를 먹이면, 알아서 Cell 크기가 유동적으로(estimated) 설정됩니다.
    // heightForRowAt은 최소 단위, estimatedHeightForRowAt은 유동적인 단위를 주는 메소드입니다.
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    enum sectionID:Int {
        case mainImageCell = 0
        case mainTextCell = 1
        case joinLikeGroupCell = 2
        case noticeListCell = 3
        case memberListCell = 4
    }
    
    // Secion Title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case sectionID.mainImageCell.rawValue:
            return nil // 모임 대표 이미지
        case sectionID.mainTextCell.rawValue:
            return "모임 소개"
        case sectionID.joinLikeGroupCell.rawValue:
            return nil // 모임 가입-좋아요 버튼
        case sectionID.noticeListCell.rawValue:
            return "공지 사항"
        case sectionID.memberListCell.rawValue:
            return "회원 목록"
        default:
            return nil
        }
    }

    
    // Custom Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case sectionID.mainImageCell.rawValue:
            return tableView.dequeueReusableCell(withIdentifier: "1stMainImageCell", for: indexPath)
        case sectionID.mainTextCell.rawValue:
            return tableView.dequeueReusableCell(withIdentifier: "2ndMainTextCell", for: indexPath)
        case sectionID.joinLikeGroupCell.rawValue:
            return tableView.dequeueReusableCell(withIdentifier: "3rdJoinLikeGroupCell", for: indexPath)
        case sectionID.noticeListCell.rawValue:
            return tableView.dequeueReusableCell(withIdentifier: "4thNoticeListCell", for: indexPath)
        case sectionID.memberListCell.rawValue:
            return tableView.dequeueReusableCell(withIdentifier: "5thMemberListCell", for: indexPath)
        case 5:
            // MARK: [리팩토링 필요!]TableView의 최하단에 여백을 넣기 위한 cell 삽입.
            let basicCell = UITableViewCell()
            let babyView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 32))
            basicCell.contentView.addSubview(babyView)
            return basicCell
        default:
            let basicCell = UITableViewCell()
            return basicCell
        }
    }
    
    // DidSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case sectionID.noticeListCell.rawValue: // 공지 사항 section
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "JSGroupBoardDetailViewController") as! JSGroupBoardDetailViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            return
        }
    }
    
}
