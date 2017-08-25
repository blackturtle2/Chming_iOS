//
//  GSRegionSearchViewController.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 25..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class GSRegionSearchViewController: UIViewController, MTMapViewDelegate, MTMapReverseGeoCoderDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var selectBtnOutlet: UIButton!
    @IBOutlet weak var mapView: MTMapView!
    @IBOutlet weak var selectAddressLabel: UILabel!
    
    var searchDelegate: GSRegionSearchProtocol?
    var resultAddress: String?
    var resultMapPoint: MTMapPoint?
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        contentView.layer.cornerRadius = contentView.frame.height / 25
        
        selectBtnOutlet.applyGradient(withColours: [#colorLiteral(red: 1, green: 0.2, blue: 0.4, alpha: 0.7),#colorLiteral(red: 1, green: 0.667937696, blue: 0.4736554623, alpha: 0.7)], gradientOrientation: .horizontal)
        selectBtnOutlet.cornerRadius()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 지도 선택시
    func mapView(_ mapView: MTMapView!, singleTapOn mapPoint: MTMapPoint!) {
        print("현재 위경도://", mapView.mapCenterPoint.mapPointGeo())
        mapView.removeAllPOIItems()
        let marker: MTMapPOIItem = MTMapPOIItem()
        marker.markerType = .redPin
        marker.mapPoint = mapPoint
        
        let selectAddress = MTMapReverseGeoCoder.findAddress(for: mapPoint, withOpenAPIKey: "719b03dd28e6291a3486d538192dca4b") ?? ""
//        marker.itemName = selectAddress
        mapView.add(marker)
        resultAddress = selectAddress
        resultMapPoint = mapPoint
        selectAddressLabel.text = selectAddress
        
    }
    
    

    @IBAction func backgroundViewTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectBtnTouched(_ sender: UIButton){
        self.dismiss(animated: true) {[unowned self] in
            guard let addressStr = self.resultAddress, let point = self.resultMapPoint else {return}
            self.searchDelegate?.returnSearchAddress(address: addressStr, mapPoint: point)
        }
    }
}

protocol GSRegionSearchProtocol {
    func returnSearchAddress(address: String, mapPoint: MTMapPoint)
}
