//
//  GSFilterMenuView.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class GSFilterMenuView: UIView {

    private var bacgroundView: UIView = UIView()
    private var distanceSort: (GSFilterMenuView)->Void = {(self) in}

    override func awakeFromNib() {
        
    }
    
    init(frame: CGRect, test: String) {
        super.init(frame: frame)
        self.bacgroundView.backgroundColor = .black
        self.bacgroundView.alpha = 0.5
        
        let filterViewFromNib: UIView = Bundle.main.loadNibNamed("GSFilterMenu", owner: self, options: nil)!.first as! UIView
        filterViewFromNib.frame = self.bounds
        filterViewFromNib.frame.origin.y = 300
        self.addSubview(filterViewFromNib)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    // 필터뷰를 addSubview 해주는메서드
    func popUp(on superView: UIView) {
        // 추후 애니메이션 작업시 필요한 프로퍼티
        //var rect:CGRect = superView.bounds
        //rect.origin.y += 64.0
        //rect.size.height -= 64.0
        self.bacgroundView.frame = superView.frame
        
        superView.addSubview(self.bacgroundView)
        superView.addSubview(self)
        
        //        self.frame.origin.y += self.movingDistance
        //        superView.addSubview(self) //애니메이션 전상황
        //        UIView.animate(withDuration: 0.4) {[unowned self] in
        //            self.frame.origin.y -= self.movingDistance
        //            self.alpha = 1.0 //애니메이션 후 상황
        //        }
        //        UIView.animate(withDuration: 0.4) {[unowned self] in
        //            self.frame.origin.y -= self.movingDistance
        //            self.alpha = 1.0 //애니메이션 후 상황
        //        }
        
    }

}
