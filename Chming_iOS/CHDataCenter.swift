//
//  CHDataCenter.swift
//  Chming_iOS
//
//  Created by CLEE on 14/08/2017.
//  Copyright © 2017 leejaesung. All rights reserved.
//

import Foundation

extension UITextField {
    
    func shapesForSignIn(){
        self.layer.cornerRadius = self.frame.height / 2
        //        self.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.5)
        self.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(hue: 348, saturation: 0, brightness: 100, alpha: 1).cgColor
        
        // placeholder 색 바꾸는 코드, string 부분을 일일이 텍스트 필드에 맞게 설정에 어려움이 있어 스토리보드로 진행
        //        self.attributedPlaceholder = NSAttributedString(string: "placeholder text",
        //                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
        
    }
    
    func shapesForSignUp(){
        self.layer.cornerRadius = self.frame.height / 2
        self.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0)
        self.layer.borderWidth = 1
        
    }
}

extension UIButton {
    
    func shapesForSignIn(){
        //        self.layer.cornerRadius = self.frame.height / 2
        //self.layer.borderWidth = 1
        //self.layer.borderColor = UIColor.init(hue: 348, saturation: 100, brightness: 100, alpha: 1).cgColor
    }
    
    
    func shapesForSignUp(){
        //        self.layer.cornerRadius = self.frame.height / 2
        //self.layer.borderWidth = 1
        //self.layer.borderColor = UIColor.init(hue: 348, saturation: 100, brightness: 100, alpha: 1).cgColor
    }
    
    func shapesForSignUpProfileImg(){
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

extension UISegmentedControl {
    
    func shapesForSignUp() {
        self.layer.cornerRadius = self.frame.height / 2
        self.tintColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
    }
}
