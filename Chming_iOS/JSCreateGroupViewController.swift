//
//  JSCreateGroupViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Toaster

class JSCreateGroupViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var scrollViewMain: UIScrollView!
    @IBOutlet var uiViewContentView: UIView!
    @IBOutlet var textFieldGroupName: UITextField!
    @IBOutlet var textViewGroupAbout: UITextView!
    
    var userPK:String? = nil

    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Singleton에 있는 UserPK 데려오기.
        // UserPK == nil 케이스 예외처리.
        guard let vCurrentUserPK = UserDefaults.standard.string(forKey: userDefaultsPk) else {
            print("///// guardlet- vCurrentUserPK")
            self.dismiss(animated: true, completion: { 
                Toast(text: "로그인 정보가 유효하지 않습니다.\r다시 로그인해주세요.").show()
            })
            
            return
        }
        
        self.userPK = vCurrentUserPK
        print("///// userPK: ", userPK ?? "(no data)")
        
        self.textFieldGroupName.delegate = self
        self.textViewGroupAbout.delegate = self
        
        self.textViewGroupAbout.layer.borderWidth = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*******************************************/
    // MARK: -  키보드 올라오는 것에 따르는 오토 스크롤  //
    /*******************************************/
    
    // 화면 다른 곳을 터치하면, 키보드 숨기기.
    @IBAction func tabHideKeyboard(_ sender: UITapGestureRecognizer) {
        self.textFieldGroupName.resignFirstResponder()
        self.textViewGroupAbout.resignFirstResponder()
    }
    
    
    /*******************************************/
    // MARK: -  Logic                          //
    /*******************************************/
    
    // MARK: 내비게이션 바에 있는 "취소" 버튼 액션 정의.
    @IBAction func buttonCancelAction(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: 내비게이션 바에 있는 "완료" 버튼 액션 정의.
    @IBAction func buttonCompleteAction(_ sender:UIButton) {
        
    }
    
    // MARK: 모임 이미지 추가 버튼 액션 정의.
    @IBAction func buttonGroupMainImageAction(_ sender:UIButton) {
        
    }
    
    // MARK: 모임 지역 버튼 액션 정의.
    @IBAction func buttonLocationAction(_ sender:UIButton) {
        
    }
    
    // MARK: 모임 관심사 버튼 액션 정의.
    @IBAction func buttonHobbyAction(_ sender:UIButton) {
        
    }
    
    
    
}
