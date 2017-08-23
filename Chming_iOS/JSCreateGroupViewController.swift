//
//  JSCreateGroupViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Toaster
import Alamofire

class JSCreateGroupViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GSCategoryProtocol {
    
    @IBOutlet var scrollViewMain: UIScrollView!
    @IBOutlet var uiViewContentView: UIView!
    @IBOutlet var textFieldGroupName: UITextField!
    @IBOutlet var textViewGroupAbout: UITextView!
    @IBOutlet var buttonGroupImageOutlet: UIButton!
    @IBOutlet var buttonLocationOutlet: UIButton!
    
    var userToken:String? = nil
    var groupImage: UIImage?
    var groupAddress: String?
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Singleton에 있는 UserPK 데려오기.
        // UserPK == nil 케이스 예외처리.
        guard let vCurrentUserToken = UserDefaults.standard.string(forKey: userDefaultsToken) else {
            print("///// guardlet- vCurrentUserPK")
            self.dismiss(animated: true, completion: { 
                Toast(text: "로그인 정보가 유효하지 않습니다.\r다시 로그인해주세요.").show()
            })
            
            return
        }
        
        self.userToken = vCurrentUserToken
        print("///// userPK: ", userToken ?? "(no data)")
        
        self.textFieldGroupName.delegate = self
        self.textViewGroupAbout.delegate = self
        
        self.textViewGroupAbout.layer.borderWidth = 1.0
//        self.buttonGroupImageOutlet.shapesForSignUpProfileImg()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // imagePickerController Delegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("///// info: ", info)
        guard let image = info["UIImagePickerControllerEditedImage"] as? UIImage else { return }
        self.groupImage = image
        self.buttonGroupImageOutlet.setBackgroundImage(image, for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }

    /*******************************************/
    // MARK: -  GSCategoryProtocol 메서드 //
    /*******************************************/
    func selectRegion(region: MTMapPoint?, regionName: String) {
        print("형뷰에서 클릭햇당")
        buttonLocationOutlet.setTitle(regionName, for: .normal)
        guard let selectMapPoint = region else {return}
        groupAddress = GSDataCenter.shared.currentLocationFullAddress(mapPoint: selectMapPoint)
        print("형뷰에서 클릭햇당 가져온 주소://",groupAddress!)
    }
    func selectCategory(categoryList: [String], categoryIndexPathList: [IndexPath]) {
        
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
        if textFieldGroupName.text == "" {
            Toast(text: "그룹명을 입력해주세요.").show()
            return
        } else if self.textViewGroupAbout.text == "" {
            Toast(text: "그룹소개를 입력해주세요.").show()
            return
        }
        guard let groupName = textFieldGroupName.text else { return }
        guard let groupAbout = textViewGroupAbout.text else { return }
        
        
        guard let token = self.userToken else {return}
        let httpHeader: HTTPHeaders = [
            "Authorization":"Token \(token)"
        ]
        var parameter: Parameters = [
            "hobby":"사진",
            "name":groupName,
            "description":groupAbout,
            "address":"서울 서초구 반포동 738-50",
            "lat" : 37.505567,
            "lng" : 127.022638
        ]
        
        if let groupProfileImage = self.groupImage {
            parameter.updateValue(groupProfileImage, forKey: "image")
        }
        guard let url = URL(string: rootDomain+"/api/group/register/") else {return}
        
        Alamofire.upload(multipartFormData: { (formData) in
            for (key, value) in parameter{
                // 이미지일경우
                if key == "image"{
                    guard let groupImage = self.groupImage else {return}
                    formData.append(UIImageJPEGRepresentation(groupImage, 0.7)!, withName: "image", fileName: groupName+"GroupImage", mimeType: "image/jpg")
                }else if key == "lat" || key == "lng" {
                    // String이 아닐경우
                    formData.append(("\(value)").data(using: .utf8)!, withName: key)
                }else{
                    formData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: httpHeader) { (encodingResult) in
            switch encodingResult {
            case .success(request: let uploadRequest, streamingFromDisk: _, streamFileURL: _):
                print("gg")
                uploadRequest.responseJSON(completionHandler: { (response) in
                    print("리스폰스 정보://", response.value)
                    
                    DispatchQueue.main.async {
                        Toast(text: "그룹 생성이 되었습니다. :D").show()
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                })
            case .failure(let err):
                print("///// registerRequest - err: ", err)
            }
        }
        
        
    
    }
    
    

    // MARK: 모임 이미지 추가 버튼 액션 정의.
    @IBAction func buttonGroupMainImageAction(_ sender:UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    // MARK: 모임 지역 버튼 액션 정의.
    @IBAction func buttonLocationAction(_ sender:UIButton) {
        let storyBoard  = UIStoryboard.init(name: "GSMapMain", bundle: nil)
        let regionViewController: GSRegionCategoryViewController = storyBoard.instantiateViewController(withIdentifier: "GSRegionCategoryView") as! GSRegionCategoryViewController
        regionViewController.categoryDelegate = self
        self.present(regionViewController, animated: true, completion: nil)
    }
    
    // MARK: 모임 관심사 버튼 액션 정의.
    @IBAction func buttonHobbyAction(_ sender:UIButton) {
        
    }
    
    
    
}
