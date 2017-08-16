//
//  GSInterestCategoryViewController.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 11..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class GSInterestCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var interestCollectionView: UICollectionView!
    var testData: [[String:Any]] = [
                                        ["pk":1,"category":"운동/스포츠", "categoryDetail":"축구"],
                                        ["pk":2,"category":"운동/스포츠", "categoryDetail":"농구"],
                                        ["pk":3,"category":"운동/스포츠", "categoryDetail":"야구"],
                                        ["pk":4,"category":"음악/악기", "categoryDetail":"베이스"],
                                        ["pk":5,"category":"음악/악기", "categoryDetail":"피아노"],
                                        ["pk":6,"category":"음악/악기", "categoryDetail":"기타"],
                                        ["pk":7,"category":"외국어/언어", "categoryDetail":"영어"],
                                        ["pk":8,"category":"외국어/언어", "categoryDetail":"불어"]
                                   ]
    var categoryDelegate: GSCategoryProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interestCollectionView.delegate = self
        interestCollectionView.dataSource = self

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
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryHeader", for: indexPath) as! GSCategoryHeaderReusableView
        
        print("뷰 포 서플리멘트리.\(indexPath)")
        header.categoryNameLabel.text = "YOUR_HEADER_TEXT"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("섹션:\(section)")
        return testData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! GSInterestCell
        cell.interestNameLabel.text = testData[indexPath.item]["categoryDetail"] as! String
        
//        cell.backgroundColor = .red
        print("cell  호출")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택한 값들을 가지고 맵에 관심모임정보 조회해야한다.
        print(testData[indexPath.item]["categoryDetail"])
        print("didSelectItemAt \(indexPath)")
        
        if collectionView.cellForItem(at: indexPath)?.backgroundColor == UIColor.blue {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.clear
        }else {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.blue
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .gray
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = nil
        print("didUnhighlightItemAt \(indexPath)")
    }
  
    
    // 4-b. -collectionView:didDeselectItemAtIndexPath: 다른 item을 Select하면서 원래 선택된 item이 Deselect 됩니다.
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("didDeselectItemAt \(indexPath)")
        
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.gray
    }
   
    @IBAction func searchBtnTouched(_ sender: UIButton){
        // 현재 선택된 관심정보 리스트를 리턴해준다.
        // GSMapMainViewController viewAppear 부분에 관심사에 해당하는 값을 전달해줘야한다.
        self.dismiss(animated: true) { 
            self.categoryDelegate?.selectCategory(categoryList: ["축구"])
        }
        
    }
}

protocol GSCategoryProtocol {
    func selectCategory(categoryList: [String])
}
