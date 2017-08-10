//
//  JSGroupBoardViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol JSGroupBoardMenuDelegate {
    func showNavigationBarPostingButton()
    func disMissNavigationBarPostingButton()
}

class JSGroupBoardViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    var groupPK:Int?
    var noticeList: [JSGroupBoard]? // 공지사항 리스트
    var commonList: [JSGroupBoard]? // 일반 게시글 리스트
    
    @IBOutlet var mainTableView:UITableView!
    
    var delegate:JSGroupBoardMenuDelegate?

    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 모임 게시판 뷰에 오면, 내비게이션 바 버튼을 바꾸려고 하는데.. 작동이 안되는 중입니다. OTL --> Delegate로 해결..
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.showNavigationBarPostingButton()
        
        guard let vSelectedGroupPK = JSDataCenter.shared.selectedGroupPK else { return }
        
        self.groupPK = vSelectedGroupPK
        self.noticeList = JSDataCenter.shared.findNoticeList(ofGroupPK: vSelectedGroupPK)
        self.commonList = JSDataCenter.shared.findGroupBoardList(ofGroupPK: vSelectedGroupPK)
        
        print("///// noticeList 234", self.noticeList ?? "no data")
        print("///// commonList 234", self.commonList ?? "no data")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.disMissNavigationBarPostingButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // XLPagerTabStrip 에서 Tab 버튼에 Indicator 정보를 등록하는 Delegate 함수입니다.
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "게시판")
    }
    
    
    
    /*********************************************/
    // MARK: -  UITableView Delegate & DataSource//
    /*********************************************/
    
    // MAKR: Number of Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // MARK: Number of Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // notice cell
            return self.noticeList?.count ?? 0
        case 1: // common cell
            return self.commonList?.count ?? 0
        default:
            return 0
        }
    }
    
    // MARK: Cell's custom height
    // 각 Cell의 AutoLayout을 Bottom까지 잘 설정한 후, UITableViewAutomaticDimension를 먹이면, 알아서 Cell 크기가 유동적으로(estimated) 설정됩니다.
    // heightForRowAt은 최소 단위, estimatedHeightForRowAt은 유동적인 단위를 주는 메소드입니다.
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: Custom Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: // notice cell
            let resultCell = tableView.dequeueReusableCell(withIdentifier: "noticeListCell", for: indexPath) as! JSGroupInfoNoticeListCell
            
            guard let vNoticeList = self.noticeList else { return resultCell }
            resultCell.labelTitle.text = vNoticeList[indexPath.row].title
            resultCell.labelContent.text = vNoticeList[indexPath.row].content
            
            return resultCell
            
        case 1: // common cell
            let resultCell = tableView.dequeueReusableCell(withIdentifier: "groupBoardCell", for: indexPath) as! JSGroupBoardCell
            
            guard let vCommonList = self.commonList else { return resultCell }
            resultCell.labelWriterName.text = vCommonList[indexPath.row].writerName
            resultCell.labelPostingDate.text = String(describing: vCommonList[indexPath.row].createdDate)
            resultCell.labelTitle.text = vCommonList[indexPath.row].title
            resultCell.labelTextContent.text = vCommonList[indexPath.row].content
            
            // 프로필 사진 출력
            guard let vWriterProfileImageURL = vCommonList[indexPath.row].writerProfileImageURL else { return resultCell }
            if let realProfileImageURL = URL(string:vWriterProfileImageURL) {
                let task = URLSession.shared.dataTask(with: realProfileImageURL, completionHandler: { (data, res, error) in
                    
                    guard let realData = data else { return }
                    DispatchQueue.main.async {
                        resultCell.imageViewWriterProfile.image = UIImage(data: realData)
                    }
                    
                })
                task.resume()
            }
            
            guard let vImageURL = vCommonList[indexPath.row].imageURL else {
                // 이미지가 없으면, constant를 0으로 줘서 cell의 height을 조절합니다.
                resultCell.constraintImageViewHeight.constant = 0
                return resultCell
            }
            if let realImageURL = URL(string: vImageURL) {
                let task = URLSession.shared.dataTask(with: realImageURL, completionHandler: { (data, res, error) in
                    print("///// data 456: ", data ?? "no data")
                    print("///// res 456: ", res ?? "no data")
                    print("///// error 456: ", error ?? "no data")
                    guard let realData = data else { return }
                    DispatchQueue.main.async {
                        resultCell.imageViewImageContent.image = UIImage(data: realData)
                    }
                })
                task.resume()
            }
            resultCell.constraintImageViewHeight.constant = self.view.frame.width * 9 / 16
            
            return resultCell
            
        default:
            return UITableViewCell()
        }
        
        
    }
    
    // MARK: DidSelectRow
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // 터치한 표시를 제거하는 액션
        tableView.deselectRow(at: indexPath, animated: true)

        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "JSGroupBoardDetailViewController") as! JSGroupBoardDetailViewController
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
