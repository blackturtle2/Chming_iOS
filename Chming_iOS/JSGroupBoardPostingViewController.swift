//
//  JSGroupBoardPostingViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 5..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class JSGroupBoardPostingViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var buttonCloseOutlet: UIButton!
    
    @IBOutlet var switcherAnnouncement: UISwitch!
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var textFieldTitle: UITextField!
    @IBOutlet var textViewContent: UITextView!
    
    @IBOutlet var imageView: UIButton!
    @IBOutlet var imageViewConstraint: NSLayoutConstraint!
    @IBOutlet var postImageView: UIImageView!
    
    @IBOutlet var buttonConfirmOutlet: UIButton!
    
    var postImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonCloseOutlet.layer.cornerRadius = buttonCloseOutlet.frame.height / 2
        buttonCloseOutlet.clipsToBounds = true
        buttonCloseOutlet.layer.borderWidth = 1
        buttonCloseOutlet.layer.borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1).cgColor
        
        textFieldTitle.layer.cornerRadius = textFieldTitle.frame.height / 2
        textFieldTitle.layer.borderWidth = 1
        textFieldTitle.layer.borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1).cgColor
        
        textViewContent.layer.cornerRadius = 8
        textViewContent.layer.borderWidth = 1
        textViewContent.layer.borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1).cgColor
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1).cgColor
        
        // 이미지가 있으면 imageView height constraint의 constant를 168.5로 변경. -> 16:9 비율 유지.
        if imageView.currentBackgroundImage != nil {
            imageViewConstraint.constant = 168.5
            imageView.layer.cornerRadius = 8
            imageView.layer.borderWidth = 0
        }
        
        buttonConfirmOutlet.layer.cornerRadius = buttonConfirmOutlet.frame.height / 2
        buttonConfirmOutlet.clipsToBounds = true
        buttonConfirmOutlet.applyGradient(withColours: [#colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1),#colorLiteral(red: 1, green: 0.667937696, blue: 0.4736554623, alpha: 1)], gradientOrientation: .horizontal)
        
        viewBackground.layer.cornerRadius = viewBackground.frame.height / 30
        viewBackground.clipsToBounds = true
        
        self.navigationController?.isNavigationBarHidden = true
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
        self.textFieldTitle.resignFirstResponder()
        self.textViewContent.resignFirstResponder()
    }
    
    
    /*************************************/
    // MARK: -  완료 버튼 Action            //
    /*************************************/
    
    @IBAction func buttonConfirm(_ sender:UIButton) {
        
        if self.textFieldTitle.text == "" {
            Toast(text: "제목을 입력해주세요.").show()
            return
        } else if self.textViewContent.text == "" {
            Toast(text: "내용을 입력해주세요.").show()
            return
        }
        
        guard let vGroupPK = JSDataCenter.shared.selectedGroupPK else { return }
        guard let vToken = UserDefaults.standard.string(forKey: userDefaultsToken) else { return }
        guard let vTextTitle = self.textFieldTitle.text else { return }
        guard let vTextContent = self.textViewContent.text else { return }
        guard let vPostImage = self.postImage else { return }
        let isNotice: Bool = self.switcherAnnouncement.isOn
        
        
        let parameter: Parameters = ["title" : vTextTitle,
                                 "content" : vTextContent,
                                 "post_img": vPostImage] // , "post_type" : isNotice,
        let header = HTTPHeaders(dictionaryLiteral: ("Authorization", "Token \(vToken)"))
        
        Alamofire.upload(multipartFormData: { (formData) in
            for (key, value) in parameter{
                // 이미지 케이스
                if key == "post_img"{
                    formData.append(UIImageJPEGRepresentation(vPostImage, 0.7)!, withName: "post_img", fileName: "\(vGroupPK)_\(vToken)", mimeType: "image/jpg")
                } else{
                    formData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            
        }, to: rootDomain + "/api/group/\(vGroupPK)/post/create/", method: .post, headers: header) { (encodingResult) in
            switch encodingResult {
            case .success(request: let uploadRequest, streamingFromDisk: _, streamFileURL: _):
                uploadRequest.responseJSON(completionHandler: { (response) in
                    print("/////3562 response: ", response)
                    
                    switch response.result {
                    case .success(let value):
                        print("/////3562 value: ", value)
                        
                        let json = JSON(value)
                        
                        if json["pk"].exists() {
                            DispatchQueue.main.async {
                                Toast(text: "글 등록이 완료 되었습니다. :D").show()
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                        
                    case .failure(let error):
                        print("/////3562 error: ", error)
                    }

                })
            case .failure(let error):
                print("/////3562 error: ", error)
            }
        }

    }
    
    
    /*************************************/
    // MARK: -  취소 버튼 Action            //
    /*************************************/
    
    @IBAction func buttonClose(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /******************************************/
    // MARK: -  이미지 등록 버튼 Action            //
    /******************************************/
    
    // 이미지 추가 버튼 액션.
    @IBAction func buttonRegisterImg(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // imagePickerController Delegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("///// info: ", info)
        guard let image = info["UIImagePickerControllerEditedImage"] as? UIImage else { return }
        self.postImage = image
//        self.imageView.setBackgroundImage(image, for: .normal)
        self.postImageView.isHidden = false
        self.postImageView.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
