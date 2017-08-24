//
//  JSGroupBoardCommentCell.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 11..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

protocol DeleteCommentDelegate {
    func reloadCommentsList()
}

class JSGroupBoardCommentCell: UITableViewCell {
    
    var writerPK: Int?
    var commentPK: Int?
    
    @IBOutlet var labelWriterName: UILabel!
    @IBOutlet var labelCreatedDate: UILabel!
    @IBOutlet var labelText: UILabel!
    
    @IBOutlet var imageViewUserProfile: UIImageView!
    @IBOutlet var buttonDeleteComment: UIButton!
    
    var delegate:DeleteCommentDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func buttonDeleteCommentAction(_ sender: UIButton) {
        // /api/group/(group_pk)/post/comment/(comment_pk)/delete/
        
        guard let vSelectedGroupPK = JSDataCenter.shared.selectedGroupPK else { return }
        guard let vCommentPK = self.commentPK else { return }
        guard let vToken = UserDefaults.standard.string(forKey: userDefaultsToken) else { return }
        
        let header = HTTPHeaders(dictionaryLiteral: ("Authorization", "Token \(vToken)"))
        
        Alamofire.request(rootDomain + "/api/group/\(vSelectedGroupPK)/post/comment/\(vCommentPK)/delete/",
            method: .delete,
            parameters: nil,
            headers: header).responseJSON(completionHandler: {[unowned self] (response) in
                
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print("/////5234 json: ", json)
                    
                    DispatchQueue.main.async {
                        Toast(text: "댓글을 삭제하였습니다. :D").show()
                        
                        self.delegate?.reloadCommentsList()
                    }
                    
                    
                case .failure(let error):
                    print("/////5234 Alamofire.request - error: ", error)
                }
                
            })
        
    }

}
