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
        nextVC.userPK = 999
        
        let nextNavi = UINavigationController(rootViewController: nextVC)
        self.present(nextNavi, animated: true, completion: nil)
    }
    
    // JSGroupMainView로 이동하는 버튼 메소드 샘플 코드.
    // groupPK를 넘겨주지 않는 경우.
    @IBAction func buttonMoveGroupMainViewNil(_ sender:UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "JSGroupMainViewController") as! JSGroupMainViewController
        
        let nextNavi = UINavigationController(rootViewController: nextVC)
        self.present(nextNavi, animated: true, completion: nil)
    }
    
    // JSGroupMainView로 이동하는 버튼 메소드 샘플 코드.
    // groupPK = 0
    @IBAction func buttonMoveGroupMainView0(_ sender:UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "JSGroupMainViewController") as! JSGroupMainViewController
        
        //"JSGroupMainViewController"로 이동할 때, groupPK를 가지고 이동합니다.
        nextVC.groupPK = 0
        
        let nextNavi = UINavigationController(rootViewController: nextVC)
        self.present(nextNavi, animated: true, completion: nil)
    }
    
    // JSGroupMainView로 이동하는 버튼 메소드 샘플 코드.
    // groupPK = 0
    @IBAction func buttonMoveGroupMainView1(_ sender:UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "JSGroupMainViewController") as! JSGroupMainViewController
        nextVC.groupPK = 1
        
        let nextNavi = UINavigationController(rootViewController: nextVC)
        self.present(nextNavi, animated: true, completion: nil)
        
    }
    
    @IBAction func buttonMoveTabbarController(_ sender:UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "JSCustomTabBarController") as! JSCustomTabBarController
        let nextNavi = UINavigationController(rootViewController: nextVC)
        
        self.present(nextNavi, animated: true, completion: nil)
        
    }
    
}
