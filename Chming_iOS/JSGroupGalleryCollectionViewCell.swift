//
//  JSGroupGalleryCollectionViewCell.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 5..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class JSGroupGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var mainImage:UIImageView!
    @IBOutlet var mainLabelTest:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainImage.image = #imageLiteral(resourceName: "IU_Sample")
        mainLabelTest.text = "Test"
        
    }
    
}
