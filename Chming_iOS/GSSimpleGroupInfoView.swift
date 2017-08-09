//
//  GSSimpleGroupInfoView.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 8..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class GSSimpleGroupInfoView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet var groupImgView: UIImageView!
    @IBOutlet var groupNameLable: UILabel!
    @IBOutlet var groupSimpleInfo: UILabel!
    
    
    
    init(frame: CGRect, groupImg: String, groupName: String, groupSimpleInfo:String) {
        super.init(frame: frame)
        let simpleInfoViewFromNib: UIView = Bundle.main.loadNibNamed("GSSimpleGroupInfo", owner: self, options: nil)!.first as! UIView
        // 인스턴스 생성시 이미지와 레이블 할당 값 구현 테스트 중입니다.
        if groupImg == "marker1_1" || groupImg == "marker1_2"{
            self.groupImgView.image = UIImage(named: groupImg)
        }else{
            self.groupImgView.image = UIImage(named: "map_pin_red.png")
        }
        self.groupImgView.contentMode = .scaleAspectFit
        self.groupNameLable.text = groupName
        self.groupSimpleInfo.text = groupSimpleInfo
        simpleInfoViewFromNib.frame = self.bounds
    
    
        self.addSubview(simpleInfoViewFromNib)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UIColor {
    
    static func rgbColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat)-> UIColor{
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

