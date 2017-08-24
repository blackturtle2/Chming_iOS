//
//  JSGroupBoardContentsCell.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 14..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Toaster
import Alamofire
import SwiftyJSON

class JSGroupBoardContentsCell: UITableViewCell {
    
    @IBOutlet var imageViewUserProfile: UIImageView!
    @IBOutlet var labelUserName: UILabel!
    @IBOutlet var labelPostedTime: UILabel!
    @IBOutlet var labelPostTitle: UILabel!
    @IBOutlet var labelPostContent: UILabel!
    @IBOutlet var imageViewContent: UIImageView!
    
    @IBOutlet var constraintImageViewHeight: NSLayoutConstraint!
    @IBOutlet var buttonPostLike: UIButton!
    
    var boardPK: Int?
    var postLikeCount: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonPostLikeAction(_ sender:UIButton) {
        
        guard let vSelectedGroupPK = JSDataCenter.shared.selectedGroupPK else { return }
        guard let vBoardPK = self.boardPK else { return }
        guard let vToken = UserDefaults.standard.string(forKey: userDefaultsToken) else { return }
        
        let header = HTTPHeaders(dictionaryLiteral: ("Authorization", "Token \(vToken)"))
        
        Alamofire.request(rootDomain + "/api/group/\(vSelectedGroupPK)/post/\(vBoardPK)/like_toggle/",
                          method: .post,
                          parameters: nil,
                          headers: header).responseJSON(completionHandler: {[unowned self] (response) in
                            
                            switch response.result {
                            case .success(let value):
                                
                                let json = JSON(value)
                                print("/////4233 json: ", json)
                                
                                if json["created"].boolValue {
                                    DispatchQueue.main.async {
                                        Toast(text: "게시글에 좋아요를 표현했습니다. :D").show()
                                        
                                        guard let vLikeCount = self.postLikeCount else { return }
                                        self.buttonPostLike.setTitle("좋아요 \(vLikeCount + 1)", for: .normal)
                                        self.postLikeCount! += 1
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        Toast(text: "좋아요를 취소했습니다. :X").show()
                                        
                                        guard let vLikeCount = self.postLikeCount else { return }
                                        self.buttonPostLike.setTitle("좋아요 \(vLikeCount - 1)", for: .normal)
                                        self.postLikeCount! -= 1
                                    }
                                }
                                
                            case .failure(let error):
                                print("/////4233 Alamofire.request - error: ", error)
                            }
                            
                          })
    }

}
