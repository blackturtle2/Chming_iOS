//
//  JSBoardDetailViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSGroupBoardDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var boardPK: Int?
    var boardData: JSGroupBoard?
    var commentListData: [JSGroupBoardComment]?
    
    @IBOutlet var constraintCommentMotherViewBottom: NSLayoutConstraint! // 댓글 작성 박스의 Constraint ( 키보드 Show/hide 용도 )
    @IBOutlet var buttonKeyboardHide: UIButton!
    
    
    @IBOutlet var mainTableView: UITableView!
    
    // 댓글 작성 뷰 IBOutlet
    @IBOutlet var commentMotherView: UIView!
    @IBOutlet var commentImageViewMyProfile: UIImageView!
    @IBOutlet var commentTextField: UITextField!
    @IBAction func commentButtonConfirm(_ sender:UIButton) {
        
    }
    
    
    /************************/
    // MARK: -  Life Cycle  //
    /************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.delegate = self
        mainTableView.dataSource = self
        commentTextField.delegate = self
        
        
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
        
        // 댓글 터치시, 키보드 올리기 위한 키보드 노티 옵저버 등록.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(JSGroupBoardDetailViewController.keyboardWillShowOrHide(notification:)),
            name: .UIKeyboardWillShow,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(JSGroupBoardDetailViewController.keyboardWillShowOrHide(notification:)),
            name: .UIKeyboardWillHide,
            object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 키보드 옵저버 해제.
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    /*************************************************************/
    // MARK: -  CommentList : UITableView Delegate & DataSource  //
    /*************************************************************/
    
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
    
    
    /**********************************/
    // MARK: -  Keyboard Show or Hide //
    /**********************************/
    
    // 키보드 Hide 버튼 액션 정의.
    @IBAction func buttonHideKeyboard(_ sender: UIButton) {
        NotificationCenter.default.post(name: .UIKeyboardWillHide, object: nil)
    }
    
    // 텍스트필드를 터치해서 Editing을 시작할 때의 액션 정의.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.buttonKeyboardHide.isHidden = false
    }
    
    // 키보드의 Return 버튼 액션 정의.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("///// textFieldShouldReturn")
        NotificationCenter.default.post(name: .UIKeyboardWillHide, object: nil)
        
        return true
    }
    
    // 키보드 올리기 or 내리기
    func keyboardWillShowOrHide(notification: Notification) {
        print("///// keyboardWillShowOrHide")
        
        // guard-let으로 nil 값이면, 키보드를 내립니다.
        guard let userInfo = notification.userInfo else {
            self.commentTextField.resignFirstResponder() // 키보드 내리기.
            self.buttonKeyboardHide.isHidden = true // 키보드 hide 버튼 감추기.
            self.constraintCommentMotherViewBottom.constant = 0 // 댓글 작성칸 내리기.
            self.view.layoutIfNeeded() // UIView layout 새로고침.
            return
        }
        
        // notification.userInfo를 이용해 키보드와 UIView를 함께 올립니다.
        print("///// userInfo: ", userInfo)
        
        let animationDuration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animationCurve = UIViewAnimationOptions(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uintValue << 16)
        let frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0.0,
            options: [.beginFromCurrentState, animationCurve],
            animations: {
                self.constraintCommentMotherViewBottom.constant = (self.view.bounds.maxY - self.view.window!.convert(frameEnd, to: self.view).minY)
                self.view.layoutIfNeeded()
        },
            completion: nil
        )
    }
    
}
