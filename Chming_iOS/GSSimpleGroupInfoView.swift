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
    var groupName: String = ""
    var groupImage: String = ""
    var groupInfo: String = ""
    var groupIndexs: String = ""
    var delegate: GSSimpleGroupInfoProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        let simpleInfoViewFromNib = UINib(nibName: "GSSimpleGroupInfo", bundle: nil).instantiate(withOwner: self, options:nil).lazy.filter{ $0 is UIView }.first as! UIView
        // loadNibNamed자체가 옵셔널 이라 옵셔널 바인딩 처리로 옵셔널 에러부분을 예외처리함
//        guard let simpleInfoViewFromNib: UIView = Bundle.main.loadNibNamed("GSSimpleGroupInfo", owner: self, options: nil)!.first as? UIView else {
//            fatalError("Could not load view from nib file.")
//            return
//        }
//        print("뷰셋 초기화")
//        simpleInfoViewFromNib.frame = self.bounds
//        self.addSubview(simpleInfoViewFromNib)
        fromNib()
    }
    
    /** 테스트중입니다 -0822
    init?(frame: CGRect, groupImg: String?, groupName: String, groupSimpleInfo:String, groupIndex: String) {
        print("심플뷰 생성자 호출")
        super.init(frame: frame)
        guard let view = Bundle.main.loadNibNamed("GSSimpleGroupInfo", owner: self, options: nil)?.first as? GSSimpleGroupInfoView else {
            return nil
        }
        view.frame = bounds
        view.addSubview(view)
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
 
//
//        let simpleInfoViewFromNib: UIView = Bundle.main.loadNibNamed("GSSimpleGroupInfo", owner: self, options: nil)!.first as! UIView
//        
        // commentByCH: 안될경우 aspectFill로 변경해서 코드로 재생.
//        self.groupImgView.contentMode = .scaleAspectFit 
        
        self.groupNameLable.text = groupName
        self.groupSimpleInfo.text = groupSimpleInfo
        self.groupIndex.text = groupIndex
        
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        
//        simpleInfoViewFromNib.frame = self.bounds
//        
//        self.addSubview(simpleInfoViewFromNib)
    }
    
    */
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        
    }
    
    func viewSetUp(groupImg: String, groupName: String, groupSimpleInfo:String, groupIndex: String, currentView:GSMapMainViewController){
        
//        indicatorView.startAnimating()
//        let simpleInfoViewFromNib: UIView = Bundle.main.loadNibNamed("GSSimpleGroupInfo", owner: self, options: nil)!.first as! UIView
        
        
        // commentByCH: 안될경우 aspectFill로 변경해서 코드로 재생.
        //        self.groupImgView.contentMode = .scaleAspectFit
        
        
        print("씸플뷰 이미지://", self.groupImage)
        
        print("뷰셋 2")
        self.groupNameLable.text = self.groupName
        self.groupSimpleInfo.text = self.groupInfo
        self.groupIndex.text = self.groupIndexs
        if let url = URL(string: self.groupImage){
            Alamofire.request(url, method: .get).responseData(completionHandler: { (data) in
                print("뷰셋 alamo")
                data.result.ifSuccess {
                    // 인스턴스 생성시 이미지와 레이블 할당 값 구현 테스트 중입니다.
                    //currentView.scrollDraging = true
                    guard let img = data.value else { return }
                    DispatchQueue.main.async {
                        self.groupImgView?.image = UIImage(data: img)
                        
                    }
                }
                
                
            })
        }else{
            print("nil 이지롱")
        }

        
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        groupImgView.layer.cornerRadius = 5
        groupImgView.clipsToBounds = true
        
//        simpleInfoViewFromNib.frame = self.bounds
//        
//        self.addSubview(simpleInfoViewFromNib)
    }
    
    func fromNib(){
        let view = Bundle.main.loadNibNamed("GSSimpleGroupInfoView", owner: self, options: nil)!.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
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
