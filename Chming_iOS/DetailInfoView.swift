//
//  DetailInfoView.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 7..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class DetailInfoView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var text: String = ""
    
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("x텍스틑 ㅌ//", text)
        groupNameLabel.text = text
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
