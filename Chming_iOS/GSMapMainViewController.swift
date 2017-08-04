//
//  GSMapMainViewController.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Firebase

class GSMapMainViewController: UIViewController, MTMapViewDelegate, MTMapReverseGeoCoderDelegate {

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
    
    func mapLoad(location: String){
        let reference = Database.database().reference()
        reference.child("GroupListMap").child(location).observeSingleEvent(of: .value, with: { (dataSnapShot) in
            let dataValue = dataSnapShot.value as! [String:Any]
            print("파이어베이스 데이터:// ", dataValue)
            
            
        })
    }
    
    // MARK: - MTMapViewDelegate 메서드(Map View Event delegate methods)
    // 테스트중
    
    // 사용자가 지도 위를 터치한 경우 호출된다.
    func mapView(_ mapView: MTMapView!, singleTapOn mapPoint: MTMapPoint!) {
        // 터치한 mapPoint 값을 MTMapPointGeo 타입으로 할당
        let geo = mapPoint.mapPointGeo()
        print("특정 지도를 터치했네요! 그곳의 위도: \(geo.latitude) , 경도: \(geo.longitude)")
        // 해당 좌표의 주소값이 필요
        
        // 좌표값을 이용하여 주소형태로 변환 방법 
        // #1. 클로저 타입인 MTMapReverseGeoCoderCompletionHandler 타입의 값을 hanlder 형태로 함수 구현한것을 프로퍼티저장
        //  MTMapReverseGeoCoder.executeFindingAddress 메서드를 통해 파리미터에 클로저 hanlder를 전달하여 메서드 수행
        let geoHandler: MTMapReverseGeoCoderCompletionHandler = {(success, addressFormapPoint, error: Error?) ->Void in
            print("//########## Geo Handler Start #######//")
            print("geoHandler success://",success)
            print("geoHandler addressFormapPoint://",addressFormapPoint)
            print("geoHandler error://",error)
            print("//########## Geo Handler End #######//")

            
        }
        MTMapReverseGeoCoder.executeFindingAddress(for: mapPoint!, openAPIKey: "719b03dd28e6291a3486d538192dca4b", completionHandler: geoHandler)
        
        // #2. String? 을 리턴하는 MTMapReverseGeoCoder.findAddress 메서드를 통해 주소 형태 문자열을 반환 받아 사용
        let result = MTMapReverseGeoCoder.findAddress(for: mapPoint, withOpenAPIKey: "719b03dd28e6291a3486d538192dca4b") ?? ""
        
        print("//@@@@@@@@@@ FindAddress Start @@@@@@@@@@ //")
        print("FindAddress: // ", result)
        print("//@@@@@@@@@@ FindAddress End @@@@@@@@@@ //")
        
        // 서울 서초구 서초동 1328-10 => '서초구' 로 잘라야됨
        // components() 메서드사용하여 공백 기준으로 분리 => ["서울", "관악구", "신림동", "441-48"]
        // 우리가 필요한 값은 index 1번 값이 필요
        let addressSplitArr: [String] = result.components(separatedBy: " ")
        print(addressSplitArr)
        self.mapLoad(location: addressSplitArr[1])
    }
    
    
    
    // MARK: - MTMapViewDelegate 메서드(User Location Tracking delegate methods)
    /*
     단말의 위치에 해당하는 지도 좌표와 위치 정확도가 주기적으로 delegate 객체에 통보된다.
     mapView :  MTMapView 객체
     location : 사용자 단말의 현재 위치 좌표
     accuracy : 현위치 좌표의 오차 반경(정확도) (meter)
     */
    // 좌표값을 주소변환 테스트 위해 잠시 주석처리합니다 -GS(20170803)
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        print("[사용자 단말의 현재 위치 좌표 값: \(location), 현위치 좌표의 오차 반경(정확도) : \(accuracy)]")
        // 주기적으로 현 위치 좌표 값을 할당
        loadCurrentMapPoint = location
        
    }
    
    
    // MARK: - MTMapReverseGeoCoderDelegate 메서드
    
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, foundAddress addressString: String!) {
        
    }
    
    // MARK: IBAction
    // 현위치이동
    @IBAction func myLocationBtnTouched(_ sender: UIButton){
        
        // 맵을 할당한 맵포인트 좌표로 이동
        mapView.setMapCenter(loadCurrentMapPoint!, animated: true)
//        self.mapLoad()
    }
    
    @IBAction func filterBtnTouched(_ sender: UIButton){
        let filtetView = GSFilterMenuView(frame: CGRect(x: 16.0, y: 20, width: self.view.frame.size.width - 32.0, height: 270.0), test: "tt")
        filtetView.popUp(on: self.view)
    }
    
    @IBAction func localFilterBtnTouched(_ sender: UIButton){
        let localFilterMenuView = GSLocalFilterMenuView(frame: CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: 300.0), localHandler: { [unowned self] (localFiterView, mapPoint) in
            print("localHandler")
            self.mapView.setMapCenter(mapPoint["localMapPoint"], zoomLevel: 3, animated: true)
            
            var items = [MTMapPOIItem]()
            // 특정 마커에 대한 커스텀 적용시
            let interestPoitItem = MTMapPOIItem()
            interestPoitItem.itemName = "축구"
            interestPoitItem.mapPoint = mapPoint["interestMapPoint"]
            interestPoitItem.markerType = MTMapPOIItemMarkerType.redPin
            interestPoitItem.markerSelectedType = MTMapPOIItemMarkerSelectedType.bluePin
            interestPoitItem.showAnimationType = MTMapPOIItemShowAnimationType.dropFromHeaven
            //interestPoitItem.draggable = true
            // tag 값은 필수는 아니지만 마커의 구분값을 사용하기 위해선 필요할거 같다.
            interestPoitItem.tag = 22
            
            items.append(interestPoitItem)
            self.mapView.addPOIItems(items)
            //화면에 나타나도록 지도 화면 중심과 확대/축소 레벨을 자동으로 조정한다
//            self.mapView.fitAreaToShowAllPOIItems()
            
        }) { (localFilterview) in
            print("cancelHandler")
            
        }
        localFilterMenuView.popUp(on: self.view)
    }

}



//
/*
extension String
{
    func substring(start: Int, end: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > self.characters.count
        {
            print("end index \(end) out of bounds")
            return ""
        }
        let startIndex = self.characters.index(self.startIndex, offsetBy: start)
        let endIndex = self.characters.index(self.startIndex, offsetBy: end)
        let range = startIndex..<endIndex
        
        return self.substring(with: range)
    }
    
    func substring(start: Int, location: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if location < 0 || start + location > self.characters.count
        {
            print("end index \(start + location) out of bounds")
            return ""
        }
        let startIndex = self.characters.index(self.startIndex, offsetBy: start)
        let endIndex = self.characters.index(self.startIndex, offsetBy: start + location)
        let range = startIndex..<endIndex
        
        return self.substring(with: range)
    }
}

*/
