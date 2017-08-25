//
//  JSBoardDetailViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class JSGroupBoardDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DeleteCommentDelegate {
    
    var groupPK: Int?
    var boardPK: Int?
    var boardData: JSGroupBoard?
    var commentListData: [JSGroupBoardComment]?
    
    @IBOutlet var constraintCommentMotherViewBottom: NSLayoutConstraint! // 댓글 작성 박스의 Constraint ( 키보드 Show/hide 용도 )
    @IBOutlet var buttonKeyboardHide: UIButton!
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var buttonDeletePost: UIButton!
    
    // 댓글 작성 뷰 IBOutlet
    @IBOutlet var commentMotherView: UIView!
    @IBOutlet var commentImageViewMyProfile: UIImageView!
    @IBOutlet var commentTextField: UITextField!
    
    
    
    /************************/
    // MARK: -  Life Cycle  //
    /************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.delegate = self
        mainTableView.dataSource = self
        commentTextField.delegate = self
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Singleton에 있는 GroupPK 데려오기.
        guard let vSelectedGroupPK = JSDataCenter.shared.selectedGroupPK else {
            print("///// guardlet- vSelectedGroupPK")
            return
        }
        
        self.groupPK = vSelectedGroupPK
        
        guard let vBoardPK = self.boardPK else { return }
        
        
        // MARK: 모임 게시판 디테일 정보에 대한 통신 로직
        Alamofire.request(rootDomain + "/api/group/\(vSelectedGroupPK)/post/\(vBoardPK)", method: .get, parameters: nil, headers: nil).responseJSON {[unowned self] (response) in
            
            switch response.result {
            case .success(let value):
                print("///// Alamofire.request - response: ", value)
                
                let json = JSON(value)
                print("///// json: ", json)
                
                self.boardData = JSDataCenter.shared.findBoardData(ofResponseJSON: json)
                self.commentListData = JSDataCenter.shared.findCommentList(ofResponseJSON: json["comment_set"])
                
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
                
            case .failure(let error):
                print("///// Alamofire.request - error: ", error)
            }
        }

        // 댓글 작성 뷰에 사용자 본인의 프로필 이미지 출력하기 위한 JSON 받아오기.
        DispatchQueue.global().async {
            guard let vToken = UserDefaults.standard.string(forKey: userDefaultsToken) else { return }
            let header = HTTPHeaders(dictionaryLiteral: ("Authorization", "Token \(vToken)"))
            
            Alamofire.request(rootDomain + "/api/user/profile/",
                              method: .get,
                              parameters: nil,
                              headers: header).responseJSON(completionHandler: {[unowned self] (response) in
                                
                                switch response.result {
                                case .success(let value):
                                    
                                    let json = JSON(value)
                                    print("/////3214 json: ", json)
                                    
                                    self.loadUserProfileImageInBottomCommentView(ofURL: json["profile_img"].stringValue)
                                    
                                case .failure(let error):
                                    print("/////3214 Alamofire.request - error: ", error)
                                }

                              })
        }
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

    
    /*******************/
    // MARK: -  Logic  //
    /*******************/
    
    // MARK: 댓글 작성 뷰의 작은 사용자 프로필 이미지 표시하는 메소드 정의.
    func loadUserProfileImageInBottomCommentView(ofURL url: String) {
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, res, err) in
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
        case 0: // MARK: 테이블뷰 - 본문
            let resultCell = tableView.dequeueReusableCell(withIdentifier: "contentsCell", for: indexPath) as! JSGroupBoardContentsCell
            
            guard let vBoardData = self.boardData else { return resultCell }
            resultCell.boardPK = vBoardData.boardPK
            resultCell.labelUserName.text = vBoardData.writerName
            resultCell.labelPostedTime.text = String(describing: vBoardData.createdDate)
            
            resultCell.labelPostTitle.text = vBoardData.title
            resultCell.labelPostContent.text = vBoardData.content
            
            resultCell.buttonPostLike.setTitle("좋아요 \(vBoardData.postLikeCount)", for: .normal)
            resultCell.postLikeCount = vBoardData.postLikeCount
            
            // 프로필 이미지 출력.
            DispatchQueue.global().async {
                guard let vWriterProfileImageURL = vBoardData.writerProfileImageURL else { return }
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
                guard let vImageURL = vBoardData.imageURL else {
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
        
        case 1: // MARK: 테이블뷰 - 댓글 리스트
            let resultCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! JSGroupBoardCommentCell
            resultCell.delegate = self
            
            guard let vUserPK = UserDefaults.standard.string(forKey: userDefaultsPk) else { return resultCell }
            guard let vCommentListData = self.commentListData else { return resultCell }
            
            resultCell.labelWriterName.text = vCommentListData[indexPath.row].writerName
            resultCell.labelText.text = vCommentListData[indexPath.row].content
            resultCell.labelCreatedDate.text = String(describing: vCommentListData[indexPath.row].createdDate)
            
            resultCell.writerPK = vCommentListData[indexPath.row].writerPK
            resultCell.commentPK = vCommentListData[indexPath.row].commentPK
            
            resultCell.buttonDeleteComment.tag = vCommentListData[indexPath.row].commentPK
            
            if vUserPK != String(vCommentListData[indexPath.row].writerPK) {
                resultCell.buttonDeleteComment.isHidden = true
            }
            
            // 댓글 프로필 이미지 출력.
            DispatchQueue.global().async {
                guard let vWriterProfileImageURL = vCommentListData[indexPath.row].writerProfileImgURL else { return }
                if let realImageURL = URL(string: vWriterProfileImageURL) {
                    let task = URLSession.shared.dataTask(with: realImageURL, completionHandler: { (data, res, err) in
                        print("///// data 3122: ", data ?? "no data")
                        print("///// res 3122: ", res ?? "no data")
                        print("///// err 3122: ", err ?? "no data")
                        
                        guard let realData = data else { return }
                        DispatchQueue.main.async {
                            resultCell.imageViewUserProfile.image = UIImage(data: realData)
                        }
                        
                    })
                    task.resume()
                }
            }
            
            return resultCell
        default:
            return UITableViewCell()
        }

    }
    
    /*****************************/
    // MARK: -  글 삭제 버튼 Action //
    /*****************************/
    
    @IBAction func buttonDeletePostAction(_ sender: UIButton){
        let alertView = UIAlertController(title: nil, message: "글을 정말 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelButtonAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okButtonAction = UIAlertAction(title: "확인", style: .destructive) {[unowned self] (action) in
            self.deleteRequest()
        }
        
        alertView.addAction(cancelButtonAction)
        alertView.addAction(okButtonAction)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func deleteRequest() {
        // /api/group/(group_pk)/post/(post_pk)/delete/

    }
    
    
    /************************/
    // MARK: -  Add Comment //
    /************************/
    
    @IBAction func commentButtonConfirm(_ sender:UIButton) {
        guard let vSelectedGroupPK = JSDataCenter.shared.selectedGroupPK else { return }
        guard let vUserPK = UserDefaults.standard.string(forKey: userDefaultsPk) else { return }
        guard let vBoardPK = self.boardPK else { return }
        guard let vToken = UserDefaults.standard.string(forKey: userDefaultsToken) else { return }
        guard let vCommentContent = self.commentTextField.text else { print("312894"); return }
        
        let header = HTTPHeaders(dictionaryLiteral: ("Authorization", "Token \(vToken)"))
        
        Alamofire.request(rootDomain + "/api/group/\(vSelectedGroupPK)/post/\(vBoardPK)/comment/create/",
            method: .post,
            parameters: ["content":vCommentContent],
            headers: header).responseJSON { (response) in
                
                switch response.result {
                case .success(let value):
                    print("/////5234 value: ", value)
                    
                    let json = JSON(value)
                    
                    if String(json["author"]["pk"].intValue) == String(vUserPK) {
                        self.loadCommentsData()
                        DispatchQueue.main.async {
                            
                            self.commentTextField.text = ""
                            
                            // Hide keyboard.
                            NotificationCenter.default.post(name: .UIKeyboardWillHide, object: nil)
                            
                            Toast(text: "댓글이 등록 되었습니다.").show()
                        }
                    }
                    
                case .failure(let error):
                    print("/////5234 error: ", error)
                }
                
        }
    }
    
    // API 통신으로 댓글 목록을 갱신하고, 테이블 뷰의 댓글 섹션을 리프레시하는 코드입니다.
    // 댓글을 등록했거나 댓글을 삭제했을 때, 사용합니다.
    func loadCommentsData() {
        // Singleton에 있는 GroupPK 데려오기.
        guard let vSelectedGroupPK = JSDataCenter.shared.selectedGroupPK else { return }
        guard let vBoardPK = self.boardPK else { return }
        
        // MARK: 댓글 리스트 리로드 통신 로직
        Alamofire.request(rootDomain + "/api/group/\(vSelectedGroupPK)/post/\(vBoardPK)", method: .get, parameters: nil, headers: nil).responseJSON {[unowned self] (response) in
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                print("/////9876 json: ", json)
                
                self.commentListData = JSDataCenter.shared.findCommentList(ofResponseJSON: json["comment_set"])
                
                DispatchQueue.main.async {
                    // Reload CommentListView
                    self.mainTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                    
                }
                
            case .failure(let error):
                print("/////9876 Alamofire.request - error: ", error)
            }
        }

    }
    
    func reloadCommentsList() {
        self.loadCommentsData()
    }
    
    
    /**********************************/
    // MARK: -  Keyboard Show or Hide //
    /**********************************/
    
    @IBAction func tapGestureHideKeyboardAction(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .UIKeyboardWillHide, object: nil)
    }
    
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
