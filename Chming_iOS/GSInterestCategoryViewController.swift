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
    
    var categorySortListArray:[GSHobbyCateogrySortingList] = []
    var categoryDelegate: GSCategoryProtocol?
    var selectedCategory: [[String]] = []
    var deatail: [String] = []
    
    var checkSelectedIndexPathArr: [IndexPath] = []
    var selectIndexPathArr: [IndexPath] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        interestCollectionView.delegate = self
        interestCollectionView.dataSource = self
        interestCollectionView.allowsMultipleSelection = true
        
    
        
        GSDataCenter.shared.getCategoryHobbyList { (categorySortListArr) in
            self.categorySortListArray = categorySortListArr
            self.interestCollectionView.reloadData()
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
        if !checkSelectedIndexPathArr.isEmpty {
            for selectedIndexPath in checkSelectedIndexPathArr {
                if selectedIndexPath == indexPath {
                    cell.isSelected = true
                }
            }
        }
        print("cell  호출")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택한 값들을 가지고 맵에 관심모임정보 조회해야한다.
        deatail = [ ]
        
        print("didSelectItemAt \(indexPath)")
        let selectItemCategory = categorySortListArray[indexPath.section].sortingData[indexPath.item].categoryDetail
        print("selectItemCategory://",selectItemCategory)
        
        let selectCell = collectionView.cellForItem(at: indexPath) as! GSInterestCell
        let selectCategoryName = selectCell.interestNameLabel.text!
        
        print("selectCategoryName://",selectCategoryName)
        print("##://", collectionView.cellForItem(at: indexPath)?.backgroundColor)
        
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
        print("상세 선택셀 데이터://",selectIndexPathArr)
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
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = nil
        print("didUnhighlightItemAt \(indexPath)")
    }
  
    // didDeselectItemAt - 지정한 패스의 항목의 선택이 해제 된 것을 위양에 통지합니다
    // 4-b. -collectionView:didDeselectItemAtIndexPath: 다른 item을 Select하면서 원래 선택된 item이 Deselect 됩니다.
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("didDeselectItemAt \(indexPath)")
        print("지정한 패스의 항목의 선택이 해제 된 것을 위양에 통지합니다.\(indexPath)")
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.gray
        if selectIndexPathArr.contains(indexPath){
            let indexInt = selectIndexPathArr.index(of: indexPath)
            print(indexInt)
            selectIndexPathArr.remove(at: indexInt!)
        }
    }
   
    @IBAction func searchBtnTouched(_ sender: UIButton){
        // 현재 선택된 관심정보 리스트를 리턴해준다.
        // GSMapMainViewController viewAppear 부분에 관심사에 해당하는 값을 전달해줘야한다.
        
        let categoryListArry = selectIndexPathArr.map { (indexpath) -> String in
            self.categorySortListArray[indexpath.section].sortingData[indexpath.item].categoryDetail
        }
        
        print("관심사 총 데이터://", categoryListArry)
        print("관심사 총 데이터://", selectIndexPathArr)
        self.dismiss(animated: true) { 
            self.categoryDelegate?.selectCategory(categoryList: categoryListArry, categoryIndexPathList:self.selectIndexPathArr)
        }
        
    }
}

protocol GSCategoryProtocol {
    func selectCategory(categoryList: [String], categoryIndexPathList: [IndexPath])
    func selectRegion(region: MTMapPoint)
}
