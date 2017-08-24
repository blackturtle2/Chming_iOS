//
//  JSGroupBoardViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON

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
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 모임 게시판 뷰에 오면, 내비게이션 바 오른쪽에 글쓰기 버튼이 생깁니다.
        delegate?.showNavigationBarPostingButton()
        
        // 다른 탭에 있는 게시판이나 갤러리 뷰에 갔다 와도 viewWillAppear()가 불리므로 네트워크-통신을 추가로 하지 않기 위한 예외처리입니다.
        // 모임 정보 데이터가 있다면, 아래 함수들을 읽지 말라는 명령.
        if self.commonList != nil { return }
        
        // Singleton에 있는 GroupPK 데려오기.
        guard let vSelectedGroupPK = JSDataCenter.shared.selectedGroupPK else {
            print("///// guardlet- vSelectedGroupPK")
            return
        }
        
        self.groupPK = vSelectedGroupPK

        // MARK: 모임 게시판 목록에 대한 통신 로직
        Alamofire.request(rootDomain + "/api/group/\(vSelectedGroupPK)/post/?page=1", method: .get, parameters: nil, headers: nil).responseJSON {[unowned self] (response) in
            
            switch response.result {
            case .success(let value):
                print("///// Alamofire.request - response: ", value)
                
                let json = JSON(value)
                print("///// json: ", json)
                
                self.noticeList = JSDataCenter.shared.findNoticeList(ofResponseJSON: json["results"])
                self.commonList = JSDataCenter.shared.findGroupBoardList(ofResponseJSON: json["results"])
                
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
                
            case .failure(let error):
                print("///// Alamofire.request - error: ", error)
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 모임 게시판 뷰에서 다른 뷰로 이동을 하면, 내비게이션 바 오른쪽에 있던 글쓰기 버튼이 사라집니다.
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
            resultCell.boardPK = vNoticeList[indexPath.row].boardPK
            resultCell.labelTitle.text = vNoticeList[indexPath.row].title
            resultCell.labelContent.text = vNoticeList[indexPath.row].content
            
            return resultCell
            
        case 1: // common cell
            let resultCell = tableView.dequeueReusableCell(withIdentifier: "groupBoardCell", for: indexPath) as! JSGroupBoardCell
            
            guard let vCommonList = self.commonList else { return resultCell }
            resultCell.boardPK = vCommonList[indexPath.row].boardPK
            resultCell.labelWriterName.text = vCommonList[indexPath.row].writerName
            resultCell.labelPostingDate.text = String(describing: vCommonList[indexPath.row].createdDate)
            resultCell.labelTitle.text = vCommonList[indexPath.row].title
            resultCell.labelTextContent.text = vCommonList[indexPath.row].content
            resultCell.labelLike.text = "좋아요 \(vCommonList[indexPath.row].postLikeCount) 댓글 \(vCommonList[indexPath.row].commentCount)"
            
            // 프로필 사진 출력
            DispatchQueue.global().async {
                guard let vWriterProfileImageURL = vCommonList[indexPath.row].writerProfileImageURL else { return }
                if let realProfileImageURL = URL(string:vWriterProfileImageURL) {
                    let task = URLSession.shared.dataTask(with: realProfileImageURL, completionHandler: { (data, res, error) in
                        
                        guard let realData = data else { return }
                        DispatchQueue.main.async {
                            resultCell.imageViewWriterProfile.image = UIImage(data: realData)
                        }
                        
                    })
                    task.resume()
                }
            }
            
            // 본문 이미지 출력
            DispatchQueue.global().async {
                guard let vImageURL = vCommonList[indexPath.row].imageURL else {
                    // 이미지가 없으면, constant를 0으로 줘서 cell의 height을 조절합니다.
                    resultCell.constraintImageViewHeight.constant = 0
                    return
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
            }
            
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
        
        switch indexPath.section {
        case 0: // notice cell
            let selectedCell = tableView.cellForRow(at: indexPath) as! JSGroupInfoNoticeListCell
            nextVC.boardPK = selectedCell.boardPK
            
        case 1: // common cell
            let selectedCell = tableView.cellForRow(at: indexPath) as! JSGroupBoardCell
            nextVC.boardPK = selectedCell.boardPK
            
        default: break
            
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
}
