//
//  JSGroupMainImageTableViewCell.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSGroupInfoImageTableViewCell: UITableViewCell {
    
    @IBOutlet var mainImage:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainImage.image = #imageLiteral(resourceName: "IU_Sample")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
