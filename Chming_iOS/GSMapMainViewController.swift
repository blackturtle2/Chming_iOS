//
//  GSMapMainViewController.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit

class GSMapMainViewController: UIViewController, MTMapViewDelegate {

    // MARK: - IBOulet
    @IBOutlet weak var mapView: MTMapView!
    var loadCurrentMapPoint: MTMapPoint?
    
    // MARK: - Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        self.loadMarker()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // viewDidLoad()에서 수행해도 괜찮습니다 - 시점차이
        //self.loadMarker()
        
        // 최초 앱 실행시 현재위치의 위도,경도 값을 서버에 전달
        
        // 현위치 트랙킹 모드 On, 단말의 위치에 따라 지도 중심이 이동한다.
        mapView.currentLocationTrackingMode = .onWithoutHeading
        
        // 현위치를 표시하는 아이콘(마커)를 화면에 표시할지 여부를 설정한다.
        // currentLocationTrackingMode property를 이용하여 현위치 트래킹 기능을 On 시키면 자동으로 현위치 마커가 보여지게 된다.
        mapView.showCurrentLocationMarker = true
//        loadCurrentMapPoint = mapView.mapCenterPoint
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        mapView.didReceiveMemoryWarning()
        
    }
    // load시 마커 리스트 셋팅 메서드
    func loadMarker() {
        var items = [MTMapPOIItem]()
        items.append(setPoiItem(name: "하나", latitude: 37.4981688, longtitude: 127.0484572))
        items.append(setPoiItem(name: "둘", latitude: 37.4987963, longtitude: 127.0415946))
        items.append(setPoiItem(name: "셋", latitude: 37.5025612, longtitude: 127.0415946))
        items.append(setPoiItem(name: "넷", latitude: 37.5037539, longtitude: 127.0426469))
        
        
        // 특정 마커에 대한 커스텀 적용시
        let poiItem2 = MTMapPOIItem()
        poiItem2.itemName = "Test"
        poiItem2.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.5176, longitude: 127.0183))
        poiItem2.markerType = MTMapPOIItemMarkerType.yellowPin
        poiItem2.markerSelectedType = MTMapPOIItemMarkerSelectedType.redPin
        poiItem2.showAnimationType = MTMapPOIItemShowAnimationType.dropFromHeaven
        poiItem2.draggable = true
        // tag 값은 필수는 아니지만 마커의 구분값을 사용하기 위해선 필요할거 같다.
        poiItem2.tag = 153
        
        items.append(poiItem2)
        mapView.addPOIItems(items)
        
        //화면에 나타나도록 지도 화면 중심과 확대/축소 레벨을 자동으로 조정한다
        mapView.fitAreaToShowAllPOIItems()
        
        // zoomLevel 할당 메서드 -  setZoomLevel(zoomLevel: MTMapZoomLevel, animated: Bool)
        // mapView.setZoomLevel(3, animated: true)
        
        //        print("현재 맵 중심점://  ",mapView.mapCenterPoint)

    }
    
    // 마커 생성 메서드
    func setPoiItem(name: String, latitude: Double, longtitude: Double) -> MTMapPOIItem {
        let poiItem = MTMapPOIItem()
        // 마커에 이름 지정
        poiItem.itemName = name
        
        // 마커 타입 지정 - 커스텀 이미지 사용시 .customImage 할당
        poiItem.markerType = .customImage
        
        // 커스텀 이미지 지정 - markerType이 customImage 경우에만 지정
        poiItem.customImage = UIImage(named: "marker1_2.png")
        
        // 선택 되었을때 마커 타입 지정
        poiItem.markerSelectedType = .customImage
        
        // 선택 되었을때 마커 이미지 지정 - markerType이 customImage 경우에만 지정
        poiItem.customSelectedImage = UIImage(named: "marker1_1.png")
        
        // 위도 경도 할당
        poiItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longtitude))
        
        // 마커가 찍히는 애니메이션 지정
        poiItem.showAnimationType = .dropFromHeaven
        
        
        poiItem.customImageAnchorPointOffset = MTMapImageOffset(offsetX: 30, offsetY: 0)
        
        // 사용자가 마커 이동 가능 여부 default: false
        //poiItem.draggable = true
        
        // 만약 말풍선 대신 커스텀뷰 지정시
        //poiItem.customCalloutBalloonView = 커스텀뷰
 
        return poiItem
    }
    
    
    // MARK: - MTMapViewDelegate 메서드(Map View Event delegate methods)
    // 테스트중
    
    // 사용자가 지도 위를 터치한 경우 호출된다.
    func mapView(_ mapView: MTMapView!, singleTapOn mapPoint: MTMapPoint!) {
        // 터치한 mapPoint 값을 MTMapPointGeo 타입으로 할당
        let geo = mapPoint.mapPointGeo()
        print("특정 지도를 터치했네요! 그곳의 위도: \(geo.latitude) , 경도: \(geo.longitude)")
        
        
    }
    
    
    
    // MARK: - MTMapViewDelegate 메서드(User Location Tracking delegate methods)
    /*
     단말의 위치에 해당하는 지도 좌표와 위치 정확도가 주기적으로 delegate 객체에 통보된다.
     mapView :  MTMapView 객체
     location : 사용자 단말의 현재 위치 좌표
     accuracy : 현위치 좌표의 오차 반경(정확도) (meter)
     */
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        print("[사용자 단말의 현재 위치 좌표 값: \(location), 현위치 좌표의 오차 반경(정확도) : \(accuracy)]")
        // 주기적으로 현 위치 좌표 값을 할당
        loadCurrentMapPoint = location
    }
    
    
    // MARK: IBAction
    // 현위치이동
    @IBAction func myLocationBtnTouched(_ sender: UIButton){
        
        // 맵을 할당한 맵포인트 좌표로 이동
        mapView.setMapCenter(loadCurrentMapPoint!, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
