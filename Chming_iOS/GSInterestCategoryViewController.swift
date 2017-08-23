//
//  GSInterestCategoryViewController.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 11..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Alamofire

class GSInterestCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var interestCollectionView: UICollectionView!
    @IBOutlet weak var searchBtnOutlet: UIButton!
    
    var categorySortListArray:[GSHobbyCateogrySortingList] = []
    var categoryDelegate: GSCategoryProtocol?
    var selectedCategory: [[String]] = []
    var deatail: [String] = []
    
    var checkSelectedIndexPathArr: [IndexPath] = []
    var checkSelectedHobbyList: [String] = []
    var selectIndexPathArr: [IndexPath] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        interestCollectionView.delegate = self
        interestCollectionView.dataSource = self
        interestCollectionView.allowsMultipleSelection = true
       
        interestCollectionView.layer.cornerRadius = interestCollectionView.frame.height / 25
        searchBtnOutlet.applyGradient(withColours: [#colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.7),#colorLiteral(red: 1, green: 0.667937696, blue: 0.4736554623, alpha: 0.7)], gradientOrientation: .horizontal)
        searchBtnOutlet.cornerRadius()
    
        
        
        GSDataCenter.shared.getCategoryHobbyList { (categorySortListArr) in
            self.categorySortListArray = categorySortListArr
            self.interestCollectionView.reloadData()
            print("체크-넘어온 indexpath:",self.checkSelectedIndexPathArr)
            if !self.checkSelectedHobbyList.isEmpty {
                print("INTEREST- 관심사뷰에서 로그인햇을경우 호출 이때 스트링 배열://",self.checkSelectedHobbyList)
                for loginUserHobby in self.checkSelectedHobbyList { // ["축구", "기타"]
                    for categoryIndex in 0..<self.categorySortListArray.count{  // 대분류 갯수: 3
                        for hobbyIndex in 0..<self.categorySortListArray[categoryIndex].sortingData.count{ // 갯수: 3
                            if loginUserHobby == self.categorySortListArray[categoryIndex].sortingData[hobbyIndex].categoryDetail {
                                print("체크-로그인시 총 관심사 리스트중 유저취미와 같을때:",loginUserHobby)
                                let userHobbyIndexPath = IndexPath(item: hobbyIndex, section: categoryIndex)
                                self.interestCollectionView.selectItem(at: userHobbyIndexPath, animated: true, scrollPosition: .centeredVertically)
                                self.selectIndexPathArr.append(userHobbyIndexPath)
                            }
                        }
                    }
                }
                
            }else{
                for indexpath in self.checkSelectedIndexPathArr {
                    print("체크 indexpath:",indexpath)
                    self.interestCollectionView.selectItem(at: indexpath, animated: true, scrollPosition: .centeredVertically)
                    self.selectIndexPathArr.append(indexpath)
                }
            }
            
        }
        // Do any additional setup after loading the view.
        
        // 서버에서 하비리스트를 가져온다 - Alomfire로 변경
//        let url = URL(string: "http://chming.jeongmyeonghyeon.com/api/group/hobby/")
//        var request: URLRequest = URLRequest(url: url!)
//        request.httpMethod = "GET"
//        
//        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            print("data : \(String.init(data: data!, encoding: .utf8))")
//            print("response : \(String(describing: response))")
//            print("error : \(String(describing: error))")
//            
//        }
//        dataTask.resume()
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categorySortListArray.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryHeader", for: indexPath) as! GSCategoryHeaderReusableView
        
        print("뷰 포 서플리멘트리.\(indexPath)")
        header.categoryNameLabel.text = categorySortListArray[indexPath.section].category
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categorySortListArray[section].sortingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! GSInterestCell
        cell.interestNameLabel.text = categorySortListArray[indexPath.section].sortingData[indexPath.item].categoryDetail
        //        cell.backgroundColor = .red
        
//        if !checkSelectedIndexPathArr.isEmpty {
//            for selectedIndexPath in checkSelectedIndexPathArr {
//                if selectedIndexPath == indexPath {
//                    cell.isSelected = true
//                    //cell.isHighlighted = true
//                    
//                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
//                    selectIndexPathArr.append(indexPath)
//                }
//            }
//        }
        
        // 로그인한 유저의 정보를 가져와서 표시하는 부분
//        if !checkSelectedHobbyList.isEmpty {
//            print("INTEREST- 관심사뷰에서 로그인햇을경우 호출 이때 스트링 배열://",checkSelectedHobbyList)
//            for hobby in checkSelectedHobbyList {
//                if hobby == categorySortListArray[indexPath.section].sortingData[indexPath.item].category {
//                    cell.isSelected = true
//                    //cell.isHighlighted = true
//                    
//                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
//                    selectIndexPathArr.append(indexPath)
//                }
//            }
//        }
        print("cell  호출")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택한 값들을 가지고 맵에 관심모임정보 조회해야한다.
        deatail = [ ]
        
        print("INTEREST-didSelectItemAt \(indexPath)")
        let selectItemCategory = categorySortListArray[indexPath.section].sortingData[indexPath.item].categoryDetail
        print("INTEREST-didSelectItemAt selectItemCategory://",selectItemCategory)
        
        let selectCell = collectionView.cellForItem(at: indexPath) as! GSInterestCell
        let selectCategoryName = selectCell.interestNameLabel.text!
        
        print("INTEREST-didSelectItemAt selectCategoryName://",selectCategoryName)
        
        if selectIndexPathArr.contains(indexPath){
            let indexInt = selectIndexPathArr.index(of: indexPath)
            print(indexInt)
            selectIndexPathArr.remove(at: indexInt!)
        }
        else{
            selectIndexPathArr.append(indexPath)
        }

//        if collectionView.cellForItem(at: indexPath)?.backgroundColor == UIColor.blue {
//            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.clear
//            print("######",selectIndexPathArr)
//            if selectIndexPathArr.contains(indexPath){
//                let indexInt = selectIndexPathArr.index(of: indexPath)
//                print(indexInt)
//                selectIndexPathArr.remove(at: indexInt!)
//            }
//        }else {
//            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.blue
////      selectCategory.append(categorySortListArray[indexPath.section].sortingData[indexPath.item].categoryDetail)
//            
//            if !selectIndexPathArr.contains(indexPath) {
//                 selectIndexPathArr.append(indexPath)
//            }
//
//        }
        print("INTEREST-상세 선택셀 데이터://",selectIndexPathArr)
    }
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    // didHighlightItemAt - 지정한 인덱스 경로의 항목이 강조 표시되었음을 델리게이트에 알립니다
//    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        print("지정한 인덱스 경로의 항목이 강조 표시되었음을 델리게이트에 알립니다.\(indexPath)")
//        let cell = collectionView.cellForItem(at: indexPath) as! GSInterestCell
//        cell.backgroundColor = .gray
//        if selectIndexPathArr.contains(indexPath){
//            let indexInt = selectIndexPathArr.index(of: indexPath)
//            print(indexInt)
//            selectIndexPathArr.remove(at: indexInt!)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GSInterestCell
//        cell?.backgroundColor = nil
        print("INTEREST-didUnhighlightItemAt:// \(selectIndexPathArr)")
        print("INTEREST-didUnhighlightItemAt \(indexPath)")
    }
  
    // didDeselectItemAt - 지정한 패스의 항목의 선택이 해제 된 것을 위양에 통지합니다
    // 4-b. -collectionView:didDeselectItemAtIndexPath: 다른 item을 Select하면서 원래 선택된 item이 Deselect 됩니다.
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("INTEREST-didDeselectItemAt \(indexPath)")
        print("INTEREST-지정한 패스의 항목의 선택이 해제 된 것을 위양에 통지합니다.\(indexPath)")
//        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.gray
        if selectIndexPathArr.contains(indexPath){
            let indexInt = selectIndexPathArr.index(of: indexPath)
            print(indexInt)
            selectIndexPathArr.remove(at: indexInt!)
        }
        print("INTEREST-didDeselectItemAt 지정한 패스의 항목의 선택이 해제 된 것을 위양에 통지합니다.\(selectIndexPathArr)")
    }
   
    @IBAction func backGroundViewTapGesture(_ sender: UITapGestureRecognizer){
        print("관심사뷰의 여백 탭제스쳐")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func searchBtnTouched(_ sender: UIButton){
        // 현재 선택된 관심정보 리스트를 리턴해준다.
        // GSMapMainViewController viewAppear 부분에 관심사에 해당하는 값을 전달해줘야한다.
        
        let categoryListArry = selectIndexPathArr.map { (indexpath) -> String in
            self.categorySortListArray[indexpath.section].sortingData[indexpath.item].categoryDetail
        }
        
        print("INTEREST-관심사 총 데이터://", categoryListArry)
        print("INTEREST-관심사 총 데이터://", selectIndexPathArr)
        self.dismiss(animated: true) { 
            self.categoryDelegate?.selectCategory(categoryList: categoryListArry, categoryIndexPathList:self.selectIndexPathArr)
        }
        
    }
}

protocol GSCategoryProtocol {
    
    func selectCategory(categoryList: [String], categoryIndexPathList: [IndexPath])
    func selectRegion(region: MTMapPoint?, regionName: String)
}
