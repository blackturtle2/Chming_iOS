//
//  JSGroupBoardCommentCell.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 11..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSGroupBoardCommentCell: UITableViewCell {
    
    var writerPK: Int?
    var commentPK: Int?
    
    @IBOutlet var labelWriterName: UILabel!
    @IBOutlet var labelCreatedDate: UILabel!
    @IBOutlet var labelText: UILabel!
    
    @IBOutlet var imageViewUserProfile: UIImageView!
    @IBOutlet var buttonDeleteComment: UIButton!
    
    @IBAction func buttonDeleteCommentAction(_ sender: UIButton) {
        
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
