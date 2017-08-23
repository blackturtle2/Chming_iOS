//
//  LoginTestViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 2..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Firebase

class JSTempMainViewController: UIViewController {
    
    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("GroupListMap").child("강남구").child("groupList").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let rootData = snapshot.value as! [String:Any]
            let myData = rootData["축구"]
            
            print("///// rootData: ", rootData)
            print("///// myData: ", myData ?? "(no data)")
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*******************************************/
    // MARK: -  Logic                          //
    /*******************************************/
    
    @IBAction func buttonMoveCreateGroupMainView(_ sender:UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "JSCreateGroupViewController") as! JSCreateGroupViewController
        
        //"JSGroupMainViewController"로 이동할 때, userPK를 가지고 이동합니다.
//        nextVC.userPK = 999
        
        let nextNavi = UINavigationController(rootViewController: nextVC)
        self.present(nextNavi, animated: true, completion: nil)
    }
    
    // JSGroupPagerTabViewController로 이동하는 버튼 메소드 샘플 코드.
    // groupPK = 1
    @IBAction func buttonMoveTabbarController(_ sender:UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "JSGroupPagerTabViewController") as! JSGroupPagerTabViewController
        nextVC.groupPK = 1
        
        let nextNavi = UINavigationController(rootViewController: nextVC)
        nextNavi.navigationBar.barTintColor = .black
        nextNavi.navigationBar.tintColor = .white
        
        self.present(nextNavi, animated: true, completion: nil)
        
    }
    
    // JSGroupMainView로 이동하는 버튼 메소드 샘플 코드.
    // groupPK를 넘겨주지 않는 경우.
    @IBAction func buttonMoveGroupMainViewNil(_ sender:UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "JSGroupPagerTabViewController") as! JSGroupPagerTabViewController
        
        let nextNavi = UINavigationController(rootViewController: nextVC)
        nextNavi.navigationBar.barTintColor = .black
        nextNavi.navigationBar.tintColor = .white
        
        self.present(nextNavi, animated: true, completion: nil)
    }
    
    
    // 임시로 작동하는 close 버튼 액션.
    @IBAction func buttonClose(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
