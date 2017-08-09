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
    
    @IBOutlet var mainTableView:UITableView!
    
    var delegate:JSGroupBoardMenuDelegate?

    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 모임 게시판 뷰에 오면, 내비게이션 바 버튼을 바꾸려고 하는데.. 작동이 안되는 중입니다. OTL
        // Delegate로 해결..
        
        mainTableView.delegate = self
        mainTableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.showNavigationBarPostingButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.disMissNavigationBarPostingButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "게시판")
    }
    
    
    
    /*********************************************/
    // MARK: -  UITableView Delegate & DataSource//
    /*********************************************/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let resultCell = tableView.dequeueReusableCell(withIdentifier: "noticeListCell", for: indexPath) as! JSGroupInfoNoticeListCell
            resultCell.labelTitle.text = "공지사항 테스트"
            resultCell.labelContent.text = "(test) 무엇을 길을 끓는 얼음과 공자는 생의 영원히 대고, 없는 것이다. 그림자는 사람은 풀밭에 원대하고, 무엇을 스며들어 넣는 위하여 칼이다."
            
            return resultCell
        case 1:
            let resultCell = tableView.dequeueReusableCell(withIdentifier: "groupBoardCell", for: indexPath) as! JSGroupBoardCell
            resultCell.labelTitle.text = "게시판 제목 테스트입니다."
            resultCell.labelTextContent.text = "(test) 힘차게 같은 들어 날카로우나 위하여서. 풀밭에 평화스러운 작고 목숨이 교향악이다. 얼마나 그들은 주는 수 철환하였는가? \n이 심장의 아니한 찬미를 약동하다. 새가 살았으며, 커다란 사막이다. 길지 이성은 속잎나고, 튼튼하며, 황금시대를 온갖 싸인 살 있는 것이다.\n싸인 방황하였으며, 미묘한 청춘을 구하지 것이 천자만홍이 철환하였는가? 기관과 물방아 곧 인생을 얼음에 칼이다. 타오르고 살 거친 밝은 있는 생의 우리 교향악이다. 노래하며 창공에 원질이 가치를 인생을 희망의 열락의 뛰노는 그들은 것이다."
            
            return resultCell
        default:
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // 터치한 표시를 제거하는 액션
        tableView.deselectRow(at: indexPath, animated: true)

        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "JSGroupBoardDetailViewController") as! JSGroupBoardDetailViewController
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
