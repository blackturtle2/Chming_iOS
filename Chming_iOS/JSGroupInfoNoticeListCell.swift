//
//  JSGroupInfoNoticeListCell.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 8..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSGroupInfoNoticeListCell: UITableViewCell {
    
    var noticePK:Int?
    
    @IBOutlet var labelTitle:UILabel!
    @IBOutlet var labelContent:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
