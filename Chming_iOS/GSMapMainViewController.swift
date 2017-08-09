//
//  GSMapMainViewController.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Firebase

class GSMapMainViewController: UIViewController, MTMapViewDelegate, MTMapReverseGeoCoderDelegate, GSSimpleGroupInfoProtocol {
    
    // ############################ IBOulet #######################################//
    // MARK: - IBOulet
    @IBOutlet weak var mapView: MTMapView!
    var loadCurrentMapPoint: MTMapPoint?
    
    @IBOutlet weak var infoScrollView: UIScrollView!
    @IBOutlet weak var scrollAreaView: UIView!
    
    
    @IBOutlet var scrollAreaWidthConstraints: NSLayoutConstraint!
    
    // ############################ Initialize #######################################//
    // MARK: - Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // 샘플코드로 마커 찍엇던 메서드를 주석처리 - 다른 마커들을 구현중이라 주석처리 합니다.
        // self.loadMarker()
        self.simpleGroupViewLoad()

        
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
    
    // ############################ 클래스 메서드 #######################################//
    // MARK: - Class Method
    
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
    
    
    // 하단 모임 간단 정보뷰를 그리는 메서드 - pk가 필요하다
    func simpleGroupViewLoad(){
        
        // -------------------------------- 스크롤뷰 테스트 start --------------------------
        // 메서드로 변경 예정
        // 스크롤뷰의 페이지느낌 속성값 - default false
        infoScrollView.isPagingEnabled = true
        // 튕기듯하 바운스 속성값 - default true
        //contentScrollView.bounces = false
        
        
        //## 코드로 구현 시작 - 강사님의 조언 어차피 데이터를 가지고 와서 그 데이터만큼 뷰를 그리고 값을 조정하기에 코드로 구현 하거나, nib구현
        // 개인적으로 닙파일로 빼야될거 같음

        // 고유 정보가 필요하다
        var count: CGFloat = 0
        var testTextNum = 0
        //infoScrollView.contentSize = CGSize(width: self.view.bounds.width*5, height: self.view.bounds.height)
        let cg: [UIColor] = [ .blue, .red, .yellow, .gray, .black]
        for index in cg {
            let simpleGroupInfoView: GSSimpleGroupInfoView = {
                let view = GSSimpleGroupInfoView(frame: CGRect(x: (self.view.bounds.size.width * count)+42, y: 0, width: self.view.bounds.size.width*0.8, height: self.infoScrollView.bounds.size.height),
                                                 groupImg: "marker1_\(testTextNum)",
                    groupName: "그룹명 \(testTextNum)",
                    groupSimpleInfo: "간단소개\(testTextNum)")
                    view.delegate = self
                    // 이동하려는 모임이 무엇인지 구분짓기위해 GSSimpleGroupInfoView에 groupPK라는 String타입프로퍼티 선언하여 할당
                    view.groupPK = "\(testTextNum)"
                view.layer.borderColor = index.cgColor
                view.layer.borderWidth = 2
                print(view.frame)
                testTextNum += 1
                return view
            }()
            
            count += 1
            scrollAreaView.addSubview(simpleGroupInfoView)
            
        }
        
        // ## 제약 사항 변경
        scrollAreaWidthConstraints.constant = self.infoScrollView.bounds.size.width*(count-1)
        // 뷰를 다시 그리는 메서드-적용된 제약사항을 가지고 새롭게 그리기만 하는 메서드이다.(viewDidLoad 등 다른 메서드와의 관계는 없다)
        self.infoScrollView.layoutIfNeeded()
        
        
        
        
        // ---------------------------- 스크롤뷰 테스트  end --------------------------
    }
    
    
    
    // ############################ MTMapViewDelegate Method #######################################//
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
    // 사용자가 POI Item을 선택한 경우 호출
    // 리턴 값은 마커 선택시 말풍선을 보여줄지 여부를 할당하는 리턴값
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        //print(scrollAreaView.subviews)
        print(poiItem.tag)
        let selectView = scrollAreaView.subviews[poiItem.tag]
        print(selectView.frame)
        
        //  scrollAreaView에 addsubview 하는 view 생성순서에 맞게 마커에 tag을 할당하여 선택한 태그의 값으로 subviews의 인덱스 값을 찾아
        // 그 뷰의 CGRect값을 이용하면서 뷰 생성시 공간을 더해줬던 42값을 다시 빼주어 가운데 위치로 갈수있도록 프로퍼티 선언 및 할당
        let moveOffsetCGRect = CGRect(x: selectView.frame.origin.x-42, y: selectView.frame.origin.y, width: selectView.frame.size.width, height: selectView.frame.size.width)
        infoScrollView.contentOffset = moveOffsetCGRect.origin
        
        // 말풍선을 보여주지 않기 위해 false를 리턴
        return false
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
    
    // ############################ IBAction #######################################//
    // MARK: IBAction
    
    // 내 위치로 이동
    @IBAction func myLocationBtnTouched(_ sender: UIButton){
        
        // 맵을 할당한 맵포인트 좌표로 이동
        mapView.setMapCenter(loadCurrentMapPoint!, animated: true)
//        self.mapLoad()
    }
    
    
    
    @IBAction func backBtnTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // 정렬버튼
    @IBAction func filterBtnTouched(_ sender: UIButton){
        let filtetView = GSFilterMenuView(frame: CGRect(x: 0, y: 200, width: self.view.frame.size.width - 32.0, height: 270.0), sortHandler: { (filterMenu) in
            print("정렬 핸들러 ")
        }) { (filterMenu) in
            print("취소 핸들러-내리기 버튼 클릭")
        }
        
        filtetView.popUp(on: self.view)
    }
    
    
    // 지역선택 버튼
    @IBAction func localFilterBtnTouched(_ sender: UIButton){
        let localFilterMenuView = GSLocalFilterMenuView(frame: CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: 300.0), localHandler: { [unowned self] (localFiterView, mapPoint) in
            print("localHandler")
            self.mapView.setMapCenter(mapPoint["localMapPoint"] as! MTMapPoint, zoomLevel: 3, animated: true)
            print("지역선택시 넘어온 데이터정보:// ",mapPoint )
            
            print(type(of: mapPoint["interestMapPoint"]))
            let interestGroupsAll:[String:Any] = mapPoint["interestMapPoint"] as! [String:Any]
            print(interestGroupsAll)
            // 작업 진행중--- 현재 2017.08.08 오후 6시 17분
            var items = [MTMapPOIItem]()
            // 특정 마커에 대한 커스텀 적용시
            

            var tagValue = 0
            for key in interestGroupsAll.keys {
                print(key)// key = "축구", "농구"
                // 각각의 키가 가지고 있는 값이 필요
                // for-in 문을 돌면서 먼저 키값을 기준으로 그룹정보가 들어있는 배열 형태로 생성
                // interestGroup = [["groupPK": "22", "groupMapPoint": <MTMapPoint: 0x608000010f60>],
                //                  ["groupPK": "23", "groupMapPoint": <MTMapPoint: 0x608000011340>]]
                let interestGroup = interestGroupsAll[key] as! [[String:Any]]
                for groupOne in interestGroup { //["groupPK": "22", "groupMapPoint": <MTMapPoint: 0x608000010f60>],
                    let interestPoitItem = MTMapPOIItem() // 마커 생성
                    // 마커에 필요한 값을 groupOne에서 가져와서 할당
                    interestPoitItem.itemName = groupOne["groupPK"] as? String ?? ""
                    interestPoitItem.mapPoint = groupOne["groupMapPoint"] as! MTMapPoint
                    print("그룸정보://", groupOne)
                    // 모임의 관심사에 따라 마커의 타입을 분기처리
                    switch key {
                    case "축구":
                        interestPoitItem.markerType = MTMapPOIItemMarkerType.redPin
                        interestPoitItem.markerSelectedType = MTMapPOIItemMarkerSelectedType.bluePin
                    case "농구":
                        interestPoitItem.markerType = MTMapPOIItemMarkerType.yellowPin
                        interestPoitItem.markerSelectedType = MTMapPOIItemMarkerSelectedType.bluePin
                    default:
                        interestPoitItem.markerType = MTMapPOIItemMarkerType.bluePin
                        interestPoitItem.markerSelectedType = MTMapPOIItemMarkerSelectedType.yellowPin
                    }
                    interestPoitItem.showAnimationType = MTMapPOIItemShowAnimationType.dropFromHeaven
                    interestPoitItem.tag = tagValue
                    items.append(interestPoitItem)
                    tagValue += 1
                    print(items)
                }
                
            }
            print(items.count)
            self.mapView.addPOIItems(items)
            

            
            
              // #단일 관심사 모임에 대한 마커를 표시했던 이전 코드
//            let groupInfo: [[String:Any]] = mapPoint["interestMapPoint"] as! [[String:Any]]
//            for groupOne in groupInfo {
//                let interestPoitItem = MTMapPOIItem()
//                interestPoitItem.itemName = groupOne["groupPK"] as? String ?? ""
//                interestPoitItem.mapPoint = groupOne["groupMapPoint"] as! MTMapPoint
//                print("그룸정보://", groupOne)
//                interestPoitItem.markerType = MTMapPOIItemMarkerType.redPin
//                interestPoitItem.markerSelectedType = MTMapPOIItemMarkerSelectedType.bluePin
//                interestPoitItem.showAnimationType = MTMapPOIItemShowAnimationType.dropFromHeaven
//                //interestPoitItem.draggable = true
//                // tag 값은 필수는 아니지만 마커의 구분값을 사용하기 위해선 필요할거 같다.
//                interestPoitItem.tag = Int(groupOne["groupPK"] as? String ?? "0")!
//                items.append(interestPoitItem)
//                print("아이템스:// ",items)
//            }
//            self.mapView.addPOIItems(items)
//            화면에 나타나도록 지도 화면 중심과 확대/축소 레벨을 자동으로 조정한다
//            self.mapView.fitAreaToShowAllPOIItems()
            
            
            // Dictionary 자체의 map메서드 - 파라미터를 클로저 함수를 가지고 있다. 뷰를 그리는 시점차이로 파악중이며 아래 for-in문으로 구현한것을 사용
//            groupInfo.map({ (groupOne) in
//                print(groupOne)
//                interestPoitItem.itemName = groupOne["groupPK"] as? String ?? ""
//                interestPoitItem.mapPoint = groupOne["groupMapPoint"] as! MTMapPoint
//                interestPoitItem.markerType = MTMapPOIItemMarkerType.redPin
//                interestPoitItem.markerSelectedType = MTMapPOIItemMarkerSelectedType.bluePin
//                interestPoitItem.showAnimationType = MTMapPOIItemShowAnimationType.springFromGround
//                //interestPoitItem.draggable = true
//                // tag 값은 필수는 아니지만 마커의 구분값을 사용하기 위해선 필요할거 같다.
//                interestPoitItem.tag = Int(groupOne["groupPK"] as? String ?? "0")!
//                items.append(interestPoitItem)
//                print("딕셔너리 맵 ")
//
//            })
            
        }) { (localFilterview) in
            print("cancelHandler")
            
        }
        localFilterMenuView.popUp(on: self.view)
    }
    
    // 커스텀뷰에서 탭 액션시 모임 정보뷰로 이동하기위해 viewcontroller가 해주어야 하는 부분이있어서 delegate 패턴으로 구현
    func nextViewPresent(nextView: JSGroupPagerTabViewController) {
        let nextNavi = UINavigationController(rootViewController: nextView)
        
        nextNavi.navigationBar.barTintColor = .black
        nextNavi.navigationBar.tintColor = .white
        
        self.present(nextNavi, animated: true, completion: nil)

    }

}
