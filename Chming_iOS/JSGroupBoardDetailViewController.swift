//
//  JSBoardDetailViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSGroupBoardDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var boardPK: Int?
    var boardData: JSGroupBoard?
    var commentListData: [JSGroupBoardComment]?
    
    
    @IBOutlet var mainTableView: UITableView!
    
    // 댓글 작성 뷰 IBOutlet
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

        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        
        guard let vBoardPK = self.boardPK else { return }
        self.boardData = JSDataCenter.shared.findBoardData(ofBoardPK: vBoardPK)
        self.commentListData = JSDataCenter.shared.findCommentList(ofBoardPK: vBoardPK)
        
        
        // 댓글 작성 뷰에 사용자 본인의 프로필 이미지 출력.
        DispatchQueue.global().async {
            guard let vUserProfileImageURL = JSDataCenter.shared.findUserProfileImageURL(ofUserPK: UserDefaults.standard.integer(forKey: userDefaultsPk)) else { return }
            
            let task = URLSession.shared.dataTask(with: vUserProfileImageURL, completionHandler: { (data, res, err) in
                print("///// data 832: ", data ?? "no data")
                print("///// res 832: ", res ?? "no data")
                print("///// err 832: ", err ?? "no data")
                
                guard let realData = data else { return }
                DispatchQueue.main.async {
                    self.commentImageViewMyProfile.image = UIImage(data: realData)
                }
            })
            task.resume()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    /***********************************************************/
    // MARK: -  CommentList : UITableView Delegate & DataSource//
    /***********************************************************/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // 게시글 섹션
            return 1
        case 1: // 댓글 섹션
            return commentListData?.count ?? 0
        default:
            return 0
        }
        
    }
    
    // MARK: Cell's custom height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // custom cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let resultCell = tableView.dequeueReusableCell(withIdentifier: "contentsCell", for: indexPath) as! JSGroupBoardContentsCell
            
            
            resultCell.labelUserName.text = self.boardData?.writerName
            resultCell.labelPostedTime.text = String(describing: (self.boardData?.createdDate)!)
            
            resultCell.labelPostTitle.text = self.boardData?.title
            resultCell.labelPostContent.text = self.boardData?.content
            
            resultCell.buttonPostLike.setTitle("좋아요 백만개", for: .normal)
            
            // 프로필 이미지 출력.
            DispatchQueue.global().async {
                guard let vWriterProfileImageURL = self.boardData?.writerProfileImageURL else { return }
                if let realProfileImageURL = URL(string: vWriterProfileImageURL) {
                    let task = URLSession.shared.dataTask(with: realProfileImageURL, completionHandler: { (data, res, err) in
                        print("///// data 231: ", data ?? "no data")
                        print("///// res 231: ", res ?? "no data")
                        print("///// err 231: ", err ?? "no data")
                        
                        guard let realData = data else { return }
                        DispatchQueue.main.async {
                            resultCell.imageViewUserProfile.image = UIImage(data: realData)
                        }
                        
                    })
                    task.resume()
                }
            }
            
            // 본문 이미지 출력.
            DispatchQueue.global().async {
                guard let vImageURL = self.boardData?.imageURL else {
                    resultCell.constraintImageViewHeight.constant = 0
                    
                    return
                    
                }
                if let realImageURL = URL(string: vImageURL) {
                    let task = URLSession.shared.dataTask(with: realImageURL, completionHandler: { (data, res, err) in
                        print("///// data 298: ", data ?? "no data")
                        print("///// res 298: ", res ?? "no data")
                        print("///// err 298: ", err ?? "no data")
                        
                        guard let realData = data else { return }
                        DispatchQueue.main.async {
                            resultCell.imageViewContent.image = UIImage(data: realData)
                        }
                        
                    })
                    task.resume()
                }
                resultCell.constraintImageViewHeight.constant = self.view.frame.width * 9 / 16
            }
            
            return resultCell
            
        case 1:
            let resultCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! JSGroupBoardCommentCell
            
            guard let vCommentListData = self.commentListData else { return resultCell }
            
            resultCell.labelWriterName.text = vCommentListData[indexPath.row].writerName
            resultCell.labelText.text = vCommentListData[indexPath.row].content
            resultCell.labelCreatedDate.text = String(describing: vCommentListData[indexPath.row].createdDate)
            
            resultCell.writerPK = vCommentListData[indexPath.row].writerPK
            resultCell.commentPK = vCommentListData[indexPath.row].commentPK
            resultCell.buttonDeleteComment.tag = vCommentListData[indexPath.row].commentPK
            
            return resultCell
        default:
            return UITableViewCell()
        }
        
        
    }
    
}
