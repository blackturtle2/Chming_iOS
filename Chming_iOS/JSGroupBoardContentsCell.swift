//
//  JSGroupBoardContentsCell.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 14..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSGroupBoardContentsCell: UITableViewCell {
    
    @IBOutlet var imageViewUserProfile: UIImageView!
    @IBOutlet var labelUserName: UILabel!
    @IBOutlet var labelPostedTime: UILabel!
    @IBOutlet var labelPostTitle: UILabel!
    @IBOutlet var labelPostContent: UILabel!
    @IBOutlet var imageViewContent: UIImageView!
    
    @IBOutlet var constraintImageViewHeight: NSLayoutConstraint!
    @IBOutlet var buttonPostLike: UIButton!
    @IBAction func buttonPostLikeAction(_ sender:UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
