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
    
    @IBOutlet var imageViewUserProfile: UIImageView!
    @IBOutlet var labelUserName: UILabel!
    @IBOutlet var labelPostedTime: UILabel!
    
    @IBOutlet var labelPostTitle: UILabel!
    @IBOutlet var labelPostContent: UILabel!
    @IBOutlet var imageViewContent: UIImageView!
    @IBOutlet var constraintContentImageView: NSLayoutConstraint! // 이미지가 없으면, 0으로 만들기.
    @IBOutlet var buttonPostLike: UIButton!
    @IBAction func buttonPostLikeAction(_ sender:UIButton) {
        
    }
    
    @IBOutlet var tableViewCommentList: UITableView!
    
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

        tableViewCommentList.delegate = self
        tableViewCommentList.dataSource = self
        
        guard let vBoardPK = self.boardPK else { return }
        self.boardData = JSDataCenter.shared.findBoardData(ofBoardPK: vBoardPK)
        
        self.labelUserName.text = self.boardData?.writerName
        self.labelPostedTime.text = String(describing: (self.boardData?.createdDate)!)
        
        self.labelPostTitle.text = self.boardData?.title
        self.labelPostContent.text = self.boardData?.content
        
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
                        self.imageViewUserProfile.image = UIImage(data: realData)
                    }
                    
                })
                task.resume()
            }
        }
        
        // 본문 이미지 출력.
        DispatchQueue.global().async {
            guard let vImageURL = self.boardData?.imageURL else {
                self.constraintContentImageView.constant = 0
                return
            }
            if let realImageURL = URL(string: vImageURL) {
                let task = URLSession.shared.dataTask(with: realImageURL, completionHandler: { (data, res, err) in
                    print("///// data 298: ", data ?? "no data")
                    print("///// res 298: ", res ?? "no data")
                    print("///// err 298: ", err ?? "no data")
                    
                    guard let realData = data else { return }
                    DispatchQueue.main.async {
                        self.imageViewContent.image = UIImage(data: realData)
                    }
                    
                })
                task.resume()
            }
        }
        
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
        
        self.buttonPostLike.setTitle("좋아요 백만개", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    /***********************************************************/
    // MARK: -  CommentList : UITableView Delegate & DataSource//
    /***********************************************************/
    
    // row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // custom cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        return resultCell
    }
    
}
