//
//  JSBoardDetailViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSGroupBoardDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var imageViewUserProfile: UIImageView!
    @IBOutlet var labelUserName: UILabel!
    @IBOutlet var labelPostedTime: UILabel!
    
    @IBOutlet var labelPostTitle: UILabel!
    @IBOutlet var labelPostContent: UILabel!
    @IBOutlet var imageViewContent: UIImageView!
    @IBOutlet var buttonPostLike: UIButton!
    @IBAction func buttonPostLikeAction(_ sender:UIButton) {
        
    }
    
    @IBOutlet var tableViewCommentList: UITableView!
    
    @IBOutlet var commentMotherView: UIView!
    @IBOutlet var commentImageViewMyProfile: UIImageView!
    @IBOutlet var commentTextField: UITextField!
    @IBAction func commentButtonConfirm(_ sender:UIButton) {
        
    }
    

    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewCommentList.delegate = self
        tableViewCommentList.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    /*********************************************/
    // MARK: -  UITableView Delegate & DataSource//
    /*********************************************/
    
    // row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // custom cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        return myCell
    }
    
}
