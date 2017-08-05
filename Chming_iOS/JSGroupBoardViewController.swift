//
//  JSGroupBoardViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class JSGroupBoardViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var mainTableView:UITableView!

    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 모임 게시판 뷰에 오면, 내비게이션 바 버튼을 바꾸려고 하는데.. 작동이 안되는 중입니다. OTL
        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "hello", style: .plain, target: nil, action: nil)
//        self.parent?.navigationItem.setRightBarButton(UIBarButtonItem(title: "hello", style: .plain, target: nil, action: nil), animated: true)
        
        mainTableView.delegate = self
        mainTableView.dataSource = self

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "groupBoardCell", for: indexPath)
        myCell.textLabel?.text = "게시판 제목 (test)"
        myCell.detailTextLabel?.text = "게시판 내용 (test)"
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "JSGroupBoardDetailViewController") as! JSGroupBoardDetailViewController
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
