//
//  JSGroupPagerTabViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import XLPagerTabStrip

let JSStoryboardName = "JSGroupMain"


class JSGroupPagerTabViewController: ButtonBarPagerTabStripViewController, JSGroupBoardMenuDelegate {
    
    var groupPK:Int? = nil // 이전 뷰에서 넘어오는 groupPK. ( 넘어오지 않았을 케이스 예외처리는 아래 viewDidLoad()에서 구현 )
    
    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // XLPagerTabStrip의 탭바 설정입니다.
        // [주의!] 스토리보드의 설정들은 먹히지 않습니다.
        let mySelectedColor = UIColor(red: 242/255, green: 40/255, blue: 46/255, alpha: 1)
        let myBackgroundColor = UIColor(red: 64/255, green: 64/255, blue: 75/255, alpha: 1)
        buttonBarView.selectedBar.backgroundColor = mySelectedColor
        buttonBarView.backgroundColor = myBackgroundColor
        settings.style.buttonBarItemBackgroundColor = myBackgroundColor
        
        
        self.navigationItem.title = "OO 모임"
        
        // groupPK 값이 오지 않았을 케이스 예외처리
        guard let vGroupPK = groupPK else {
            print("///// groupPK is no data-")
            
            let alertViewController = UIAlertController(title: "알림", message: "인터넷 연결이 불안정합니다. 잠시 후, 다시 시도해주세요.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "ok", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            alertViewController.addAction(alertAction)
            self.present(alertViewController, animated: true, completion: nil)
            
            return
        }
        
        print("///// groupPK: ", vGroupPK)
        JSDataCenter.shared.selectedGroupPK = vGroupPK // Singleton에 선택한 모임 PK 저장.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
//         // 뷰가 닫힐 때, Singleton에 있던 선택한 모임 PK 데이터 삭제.
//        JSDataCenter.shared.selectedGroupPK = nil
        // 모임 게시판 뷰에서 내비게이션 컨트롤러 푸시할 때도 싱글턴의 GroupPK가 사라져서 주석 처리.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /***************************************************/
    // MARK: -  Add ViewControllers to XLPagerTabStrip //
    /***************************************************/
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: JSStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "JSGroupInfoViewController") as! JSGroupInfoViewController
        
        let child_2 = UIStoryboard(name: JSStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "JSGroupBoardViewController") as! JSGroupBoardViewController
        child_2.delegate = self // 게시판 뷰로 이동했을 때, 내비게이션 바의 오른쪽에 "글 작성" 버튼을 추가하기 위한 delegate 입니다. 아래에 function 구현이 있습니다.
        
        let child_3 = UIStoryboard(name: JSStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "JSGroupGalleryViewController") as! JSGroupGalleryViewController
        
        return [child_1, child_2]
    }
    
    
    /*******************************************/
    // MARK: -  Close Button Action            //
    /*******************************************/
    
    @IBAction func buttonClose(_ sender:UIButton) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /**********************************************/
    // MARK: -  JSGroupBoardMenuDelegate function //
    /**********************************************/
    
    // 게시판 뷰가 로드될 때, 내비게이션 바에 글 작성 버튼 보이게 하는 function.
    func showNavigationBarPostingButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_create_white"), style: .plain, target: self, action: #selector(moveJSGroupBoardPostingView))
    }
    
    // 글 작성 버튼을 눌렀을 때, 글 작성 뷰로 이동.
    func moveJSGroupBoardPostingView() {
        let rootVC = self.storyboard?.instantiateViewController(withIdentifier: "JSGroupBoardPostingViewController") as! JSGroupBoardPostingViewController
        let nextVC = UINavigationController(rootViewController: rootVC)
        
        self.present(nextVC, animated: true, completion: nil)
    }
    
    // 게시판 뷰에서 빠져나올 때(모임 정보나 갤러리 뷰로 이동할 때) 글 작성 버튼을 없애는 function.
    func disMissNavigationBarPostingButton() {
        self.navigationItem.rightBarButtonItem = nil
    }

}
