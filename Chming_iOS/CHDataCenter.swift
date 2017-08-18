//
//  CHDataCenter.swift
//  Chming_iOS
//
//  Created by CLEE on 14/08/2017.
//  Copyright © 2017 leejaesung. All rights reserved.
//

import UIKit

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
        self.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.1)
        
//        self.layer.borderWidth = 1
//        self.layer.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.3).cgColor
        
    }
    
    func roundedButton(corners:UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        self.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.1)
        
//        self.layer.borderWidth = 1
//        self.layer.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.3).cgColor
    }
    

}

extension UIButton {
    
    func cornerRadius() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    func shapesForSignUp(){
        //        self.layer.cornerRadius = self.frame.height / 2
        //self.layer.borderWidth = 1
        //self.layer.borderColor = UIColor.init(hue: 348, saturation: 100, brightness: 100, alpha: 1).cgColor
        self.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.1)
        self.layer.borderWidth = 1
        self.layer.borderColor = tintColor.cgColor
        self.titleLabel?.textColor = tintColor
    }
    
    func shapesForRegisterBtnAtSignUp() {
        self.layer.cornerRadius = self.frame.height / 2
//        self.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0)
        self.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.1)
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.3).cgColor
        
    }
    
    func shapesForSignUpProfileImg(){
        shapesForSignUp()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.3).cgColor
        self.setTitleColor(#colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.3), for: .normal)
        
    }
    
    func roundedButton(corners:UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        self.backgroundColor = #colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 0.5)
        
//        self.layer.borderWidth = 1
//        self.layer.borderColor = #colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 1).cgColor
    }
    
    
    func applyGradient(withColours colours: [UIColor], locations:[NSNumber]? = nil) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint

        self.layer.insertSublayer(gradient, at: 0)
    }


}

extension UISegmentedControl {

    func shapesCustomizing() {
        self.tintColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.3)
        
        self.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.1)
        self.layer.cornerRadius = self.frame.height / 2
 
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.3).cgColor
        
        // clipsToBounds 같은 거
        self.layer.masksToBounds = true
//        self.clipsToBounds = true

        
        
        // 세그먼트 보더라인 지우는 소스 - 이해 X
//        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
//        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
//        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
//        
//    }
//    
//    // create a 1x1 image with this color
//    private func imageWithColor(color: UIColor) -> UIImage {
//        
//        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
//        UIGraphicsBeginImageContext(rect.size)
//        
//        let context = UIGraphicsGetCurrentContext()
//        context!.setFillColor(color.cgColor);
//        context!.fill(rect);
//        
//        let image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        return image!
//        
    }
    

}




typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    
    var startPoint: CGPoint {
        return points.startPoint
    }
    
    var endPoint: CGPoint {
        return points.endPoint
    }
    
    var points: GradientPoints {
        switch self {
        case .topRightBottomLeft:
            return (CGPoint.init(x: 0.0, y: 1.0), CGPoint.init(x: 1.0, y: 0.0))
            
        case .topLeftBottomRight:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 1.0, y: 1.0))
        
        case .horizontal:
            return (CGPoint.init(x: 0.0, y: 0.5), CGPoint.init(x: 1.0, y: 0.5))
            
        case .vertical:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 0.0, y: 1.0))
        }
    }
}
