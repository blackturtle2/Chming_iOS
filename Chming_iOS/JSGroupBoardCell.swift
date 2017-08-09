//
//  JSGroupBoardCell.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 9..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSGroupBoardCell: UITableViewCell {
    
    @IBOutlet var imageViewWriterProfile:UIImageView!
    @IBOutlet var labelWriterName:UILabel!
    @IBOutlet var labelPostingDate:UILabel!
    @IBOutlet var labelTitle:UILabel!
    @IBOutlet var labelTextContent:UILabel!
    @IBOutlet var imageViewImageContent:UIImageView!
    @IBOutlet var labelLike:UILabel!

    @IBOutlet var constraintImageViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
