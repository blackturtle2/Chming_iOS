//
//  GSInterestCell.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 15..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class GSInterestCell: UICollectionViewCell {
    @IBOutlet weak var interestNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1).cgColor
        self.layer.cornerRadius = self.layer.bounds.size.height/2
    }
    override var isSelected: Bool{
        didSet{
            if isSelected{
                self.backgroundColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
                self.interestNameLabel.textColor = .white
            }else {
                self.backgroundColor = .clear
                self.interestNameLabel.textColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            }
        }
    }
}
