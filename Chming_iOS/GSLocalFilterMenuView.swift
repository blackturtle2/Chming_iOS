//
//  GSLocalFilterMenuView.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

typealias ComposeActionHandler = ((GSLocalFilterMenuView) -> Void)

class GSLocalFilterMenuView: UIView {
    
    // 배경 뷰
    private var bacgroundView: UIView = UIView()
    // 버튼 실행시 이루어질 핸들러 선언
    private var localHandler: (GSLocalFilterMenuView, [String : Any])->Void = {(self) in}
    private var cancleHandler: ((GSLocalFilterMenuView)->Void)?
    
    // 생성시 frame 값과, 지역버튼 클릭시에 일어날 행동에 대한 클로저 함수를 파라미터로 할당
    init(frame: CGRect, localHandler: @escaping (GSLocalFilterMenuView, [String: Any])->Void , cancleHandler: ComposeActionHandler?) {
        super.init(frame: frame)
        self.loadNib()
        self.bacgroundView.backgroundColor = .black
        self.bacgroundView.alpha = 0.7
        self.localHandler = localHandler
        self.cancleHandler = cancleHandler
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Nib 파일 초기 로드시 필요 메서드
    private func loadNib() {
        let viewFromNib: UIView = Bundle.main.loadNibNamed("GSLocalFilterMenu", owner: self, options: nil)!.first as! UIView
        viewFromNib.frame = self.bounds
        viewFromNib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(viewFromNib)
    }
    
    @IBAction func localBtnTouched(_ sender: UIButton){
        print(sender.titleLabel?.text)
        let selectLocal = sender.titleLabel?.text ?? ""
        let mapPoint = GSDataCenter.shared.selectLocalMapPoint(local: selectLocal)
        // 리턴 받은 좌표를 뷰에서 이동 해야함 맵뷰 객체에 전달 해야한다.
        
        
        self.bacgroundView.removeFromSuperview()
        self.removeFromSuperview()
        
        localHandler(self, mapPoint)
    }
    
    @IBAction func cancelBtnTouched(_ sender: UIButton){
        self.bacgroundView.removeFromSuperview()
        self.removeFromSuperview()

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
