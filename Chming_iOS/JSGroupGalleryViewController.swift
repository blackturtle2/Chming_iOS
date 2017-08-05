//
//  JSGroupGalleryViewController.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class JSGroupGalleryViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var mainCollectionView:UICollectionView!

    
    
    /*******************************************/
    // MARK: -  Life Cycle                     //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "갤러리")
    }
    
    
    
    /**************************************************/
    // MARK: -  UICollectionView Delegate & DataSource//
    /**************************************************/
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCollectionViewCell", for: indexPath) as! JSGroupGalleryCollectionViewCell
        
        return myCell
        
    }
  
}
