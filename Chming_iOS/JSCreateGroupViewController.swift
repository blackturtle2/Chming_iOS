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

class JSCreateGroupViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GSCategoryProtocol, GSRegionSearchProtocol {
    
    @IBOutlet var scrollViewMain: UIScrollView!
    @IBOutlet var uiViewContentView: UIView!
    @IBOutlet var textFieldGroupName: UITextField!
    @IBOutlet var textViewGroupAbout: UITextView!
    @IBOutlet var buttonGroupImageOutlet: UIButton!
    @IBOutlet var buttonLocationOutlet: UIButton!
    @IBOutlet var buttonHobbyOutlet: UIButton!
    
    var userToken:String? = nil
    var groupImage: UIImage?
    var groupAddress: String?
    var grouplat: Double?
    var grouplng: Double?
    var regionName: String?
    var hobby: String?
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
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
        self.textFieldGroupName.shapesForSignUp()
        self.textViewGroupAbout.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.1)
        self.textViewGroupAbout.layer.cornerRadius = self.textViewGroupAbout.frame.height / 15
        
        self.buttonLocationOutlet.shapesForRegisterBtnAtSignUp()
        self.buttonHobbyOutlet.shapesForRegisterBtnAtSignUp()
        
//        self.textViewGroupAbout.layer.borderWidth = 1.0
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
        self.buttonGroupImageOutlet.setTitle("", for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func shapesForTextView(){
        //        self.layer.cornerRadius = self.frame.height / 2
        //self.layer.borderWidth = 1
        //self.layer.borderColor = UIColor.init(hue: 348, saturation: 100, brightness: 100, alpha: 1).cgColor
        self.textViewGroupAbout.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.1)
        //self.textViewGroupAbout.borderWidth = 1
//        self.textViewGroupAbout.borderColor = tintColor.cgColor
//        self.titleLabel?.textColor = tintColor
    }
    

    /*******************************************/
    // MARK: -  GSCategoryProtocol 메서드 //
    /*******************************************/
    func selectRegion(region: MTMapPoint?, regionName: String) {
        
        buttonLocationOutlet.setTitle(regionName, for: .normal)
        self.regionName = regionName
        guard let selectMapPoint = region else {return}
        self.groupAddress = GSDataCenter.shared.currentLocationFullAddress(mapPoint: selectMapPoint)
        self.grouplat = selectMapPoint.mapPointGeo().latitude
        self.grouplng = selectMapPoint.mapPointGeo().longitude
        
    }
    func selectCategory(categoryList: [String], categoryIndexPathList: [IndexPath]) {
        
        buttonHobbyOutlet.setTitle(categoryList.first ?? "", for: .normal)
        self.hobby = categoryList.first
        
        
    }
    /*******************************************/
    // MARK: -  GSRegionSelectProtocol Method  //
    /*******************************************/
    func returnSearchAddress(address: String, mapPoint: MTMapPoint) {
        print("검색결과://", address, "/",mapPoint.mapPointGeo())
        self.groupAddress = address
        self.grouplat = mapPoint.mapPointGeo().latitude
        self.grouplng = mapPoint.mapPointGeo().longitude
        buttonLocationOutlet.setTitle(address, for: .normal)
    }
    
    /*******************************************/
    // MARK: -  UITextFieldDelegate Method      //
    /*******************************************/
    // 뷰 올리기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollViewMain.setContentOffset(CGPoint(x: 0.0, y: 100.0), animated:true)
    }
    
    // 뷰 내리기
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollViewMain.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    // 리턴키 설정
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textFieldGroupName {
            textViewGroupAbout.text = ""
            textViewGroupAbout.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        
        return true
        
    }
    
    /*******************************************/
    // MARK: -  UITextViewDelegate Method      //
    /*******************************************/
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.scrollViewMain.setContentOffset(CGPoint(x: 0.0, y: self.textViewGroupAbout.frame.origin.y/2), animated:true)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.scrollViewMain.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
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
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: 내비게이션 바에 있는 "완료" 버튼 액션 정의.
    @IBAction func buttonCompleteAction(_ sender:UIButton) {
        if textFieldGroupName.text == "" {
            Toast(text: "그룹명을 입력해주세요.").show()
            return
        } else if self.textViewGroupAbout.text == "" {
            Toast(text: "그룹소개를 입력해주세요.").show()
            return
        } else if self.groupAddress == nil || self.groupAddress == ""{
            Toast(text: "그룹모임 지역을 선택해주세요.").show()
            return
        } else if self.hobby == nil || self.hobby == ""{
            Toast(text: "그룹모임 분야를 선택해주세요.").show()
            return
        }
        
        guard let groupName = textFieldGroupName.text else { return }
        guard let groupAbout = textViewGroupAbout.text else { return }
        guard let groupAddress = groupAddress else {return}
        guard let hobby = hobby else {return}
        guard let grouplat = grouplat else {return}
        guard let grouplng = grouplng else {return}
        
        
        
        guard let token = self.userToken else {return}
        let httpHeader: HTTPHeaders = [
            "Authorization":"Token \(token)"
        ]
        var parameter: Parameters = [
            "hobby":hobby,
            "name":groupName,
            "description":groupAbout,
            "address":groupAddress,
            "lat" : grouplat,
            "lng" : grouplng
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
//        let storyBoard  = UIStoryboard.init(name: "GSMapMain", bundle: nil)
//        let regionViewController: GSRegionCategoryViewController = storyBoard.instantiateViewController(withIdentifier: "GSRegionCategoryView") as! GSRegionCategoryViewController
//        regionViewController.categoryDelegate = self
//        self.present(regionViewController, animated: true, completion: nil)
        let storyBoard  = UIStoryboard.init(name: "GSMapMain", bundle: nil)
        let regionViewController: GSRegionSearchViewController = storyBoard.instantiateViewController(withIdentifier: "GSRegionSearchView") as! GSRegionSearchViewController
        regionViewController.searchDelegate = self
        
        self.present(regionViewController, animated: true, completion: nil)
    }
    
    // MARK: 모임 관심사 버튼 액션 정의.
    @IBAction func buttonHobbyAction(_ sender:UIButton) {
        let storyBoard  = UIStoryboard.init(name: "GSMapMain", bundle: nil)
        let interestViewController: GSInterestCategoryViewController = storyBoard.instantiateViewController(withIdentifier: "GSInterestCategoryView") as! GSInterestCategoryViewController
        interestViewController.categoryDelegate = self
        interestViewController.useMultitoutch = false
        self.present(interestViewController, animated: true, completion: nil)
    }
    
    
    
}
