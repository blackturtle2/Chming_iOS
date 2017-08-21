//
//  GSRegionCell.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 21..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class GSRegionCell: UICollectionViewCell {
    
    @IBOutlet weak var regionNameLabel: UILabel!
    
    var mapPoint: MTMapPoint = MTMapPoint()
    
    override func awakeFromNib() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.layer.bounds.size.height/2
    }
    
    // CollectionView Cell isSelected 값에 따라 색변경
    override var isSelected: Bool {
        didSet{
            if isSelected{
                self.backgroundColor = .black
                self.regionNameLabel.textColor = .white
            }else {
                self.backgroundColor = .white
                self.regionNameLabel.textColor = .black
            }
        }
    }
}
