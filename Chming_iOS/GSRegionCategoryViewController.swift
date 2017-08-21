//
//  GSRegionCategoryViewController.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 20..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class GSRegionCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var regionCollectionView: UICollectionView!
    
    var categorySortListArray:[GSRegionCategorySortingList] = []
    var categoryDelegate: GSCategoryProtocol?
    var selectCategory: [[String]] = []
    var deatail: [String] = []
    
    
    var selectMapPoint: MTMapPoint = MTMapPoint()
    override func viewDidLoad() {
        super.viewDidLoad()
        regionCollectionView.delegate = self
        regionCollectionView.dataSource = self
        
        
        
//        self.categorySortListArray = categorySortListArr
//        self.regionCollectionView.reloadData()
        
        GSDataCenter.shared.getCategoryRegionList { (categoryListArr) in
            self.categorySortListArray = categoryListArr
            self.regionCollectionView.reloadData()
        }
        // Do any additional setup after loading the view.
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegionCell", for: indexPath) as! GSRegionCell
        let lat  = categorySortListArray[indexPath.section].sortingData[indexPath.item].lat
        let lng = categorySortListArray[indexPath.section].sortingData[indexPath.item].lng
        cell.regionNameLabel.text = categorySortListArray[indexPath.section].sortingData[indexPath.item].dong
        cell.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: lat, longitude: lng))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택한 값들을 가지고 맵에 관심모임정보 조회해야한다.
       
        let selectCell = collectionView.cellForItem(at: indexPath) as! GSRegionCell
        
        selectMapPoint = selectCell.mapPoint
        print("선택 지역의 위경도-://", selectMapPoint)
//        if collectionView.cellForItem(at: indexPath)?.backgroundColor == UIColor.blue {
//            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.clear
//            print("컬렉션뷰 색이 블루=> 이미 선택했던것 다시 선택시 호출")
//
//        }else {
//            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.blue
//            collectionView.cellForItem(at: indexPath)?.selectedBackgroundView?.backgroundColor = .red
//            print("컬렉션뷰 색이 블루가 아님=> 셀 선택시")
//            latitude = categorySortListArray[indexPath.section].sortingData[indexPath.item].lat
//            longtitude = categorySortListArray[indexPath.section].sortingData[indexPath.item].lng
//            print(latitude,"/",longtitude)
//            selectMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longtitude))
//            //      selectCategory.append(categorySortListArray[indexPath.section].sortingData[indexPath.item].categoryDetail)
//            
//            
//            
//        }
        
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
    
    
    
    // didDeselectItemAt - 지정한 패스의 항목의 선택이 해제 된 것을 위양에 통지합니다
    // 4-b. -collectionView:didDeselectItemAtIndexPath: 다른 item을 Select하면서 원래 선택된 item이 Deselect 됩니다.
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("컬렉션뷰 didDeselectItemAt \(indexPath)")
        print("컬렉션뷰 지정한 패스의 항목의 선택이 해제 된 것을 위양에 통지합니다.\(indexPath)")
//        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.gray
//        if selectIndexPathArr.contains(indexPath){
//            let indexInt = selectIndexPathArr.index(of: indexPath)
//            print(indexInt)
//            selectIndexPathArr.remove(at: indexInt!)
//        }
        selectMapPoint = MTMapPoint()
    }
    
//    @IBAction func searchBtnTouched(_ sender: UIButton){
//        // 현재 선택된 관심정보 리스트를 리턴해준다.
//        // GSMapMainViewController viewAppear 부분에 관심사에 해당하는 값을 전달해줘야한다.
//        
//        let categoryListArry = selectIndexPathArr.map { (indexpath) -> String in
//            self.categorySortListArray[indexpath.section].sortingData[indexpath.item].categoryDetail
//        }
//        print("관심사 총 데이터://", categoryListArry)
//        
//        self.dismiss(animated: true) {
//            self.categoryDelegate?.selectCategory(categoryList: categoryListArry)
//        }
//        
//    }

    @IBAction func searchBtnTouched(_ sender: UIButton){
        self.dismiss(animated: true) { 
            self.categoryDelegate?.selectRegion(region: self.selectMapPoint)
        }
    }
}
