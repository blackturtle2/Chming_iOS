//
//  GSSimpleGroupInfoView.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 8..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Alamofire

class GSSimpleGroupInfoView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var groupImgView: UIImageView!
    @IBOutlet weak var groupNameLable: UILabel!
    @IBOutlet weak var groupSimpleInfo: UILabel!
    @IBOutlet weak var groupIndex: UILabel!
    var groupPK: String = ""
    var delegate: GSSimpleGroupInfoProtocol?

    init(frame: CGRect, groupImg: String?, groupName: String, groupSimpleInfo:String, groupIndex: String) {
        super.init(frame: frame)
        
        if let img = groupImg  {
            let url = URL(string: img)
            
            // 별도의 쓰레드 관리를 방지하기 위해 Alamofire 사용하여 통신
            Alamofire.request(url!, method: .get).responseData(completionHandler: { (data) in
                DispatchQueue.main.async {
                    // 인스턴스 생성시 이미지와 레이블 할당 값 구현 테스트 중입니다.
                    if let imgData = data.value {
    
                        self.groupImgView.image = UIImage(data: imgData)
                    }else{
                        self.groupImgView.image = UIImage(named: "marker1_1.png")
                    }
                    
                }
            })
        }else{ // 0817 - 그룹이미지 부분에 대해 URL이 없는 경우 어떤식으로 대체할지 아직 서버쪽에 이야기를 듣지못해 임시로 디폴트 이미지처리함
            self.groupImgView.image = UIImage(named: "marker1_1.png")
            
        }
//        URLSession.shared.dataTask(with: url!) { (data, response, error) in
//            DispatchQueue.main.async {
//                guard let imgData = data else {return}
//                // 인스턴스 생성시 이미지와 레이블 할당 값 구현 테스트 중입니다.
//                self.groupImgView.image = UIImage(data: imgData)
//                
//            }
//        }.resume(
        let simpleInfoViewFromNib: UIView = Bundle.main.loadNibNamed("GSSimpleGroupInfo", owner: self, options: nil)!.first as! UIView
        
        // commentByCH: 안될경우 aspectFill로 변경해서 코드로 재생.
//        self.groupImgView.contentMode = .scaleAspectFit 
        
        self.groupNameLable.text = groupName
        self.groupSimpleInfo.text = groupSimpleInfo
        self.groupIndex.text = groupIndex
        
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        
        simpleInfoViewFromNib.frame = self.bounds
        
        self.addSubview(simpleInfoViewFromNib)
    }
    
//    init(frame: CGRect, groupImg: String, groupName: String, groupSimpleInfo:String) {
//        super.init(frame: frame)
//        let url = URL(string: "https://www.gstatic.com/webp/gallery3/1.png")
//        URLSession.shared.dataTask(with: url!) { (data, response, error) in
//            DispatchQueue.main.async {
//                guard let imgData = data else {return}
//                // 인스턴스 생성시 이미지와 레이블 할당 값 구현 테스트 중입니다.
//                if groupImg == "marker1_1" || groupImg == "marker1_2"{
//                    self.groupImgView.image = UIImage(named: groupImg)
//                }else{
//                    self.groupImgView.image = UIImage(data: imgData)
//                }
//            }
//        }.resume()
//        let simpleInfoViewFromNib: UIView = Bundle.main.loadNibNamed("GSSimpleGroupInfo", owner: self, options: nil)!.first as! UIView
//        
//        self.groupImgView.contentMode = .scaleAspectFit
//        self.groupNameLable.text = groupName
//        self.groupSimpleInfo.text = groupSimpleInfo
//        simpleInfoViewFromNib.frame = self.bounds
//    
//    
//        self.addSubview(simpleInfoViewFromNib)
//    }
//    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func simpleVieTapGesture(_ sender: UITapGestureRecognizer) {
        print("탭  제스쳐", self.groupPK)
        let storyBoard  = UIStoryboard.init(name: "JSGroupMain", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "JSGroupPagerTabViewController") as! JSGroupPagerTabViewController
        
        //"JSGroupMainViewController"로 이동할 때, userPK를 가지고 이동합니다.
        nextVC.groupPK = Int(self.groupPK)
        
                
        self.delegate?.nextViewPresent(nextView: nextVC)
        
    }
}

extension UIColor {
    
    static func rgbColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat)-> UIColor{
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


protocol GSSimpleGroupInfoProtocol {
    func nextViewPresent(nextView: JSGroupPagerTabViewController)
}
