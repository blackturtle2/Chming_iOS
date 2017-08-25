//
//  GSMapMainViewController.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON



class GSMapMainViewController: UIViewController, MTMapViewDelegate, MTMapReverseGeoCoderDelegate, GSSimpleGroupInfoProtocol, GSCategoryProtocol ,UIScrollViewDelegate, loginCompleteDelegate {
    
    // MARK: - Property
    var locationFullAddress: String = ""
    
    // 데이터센터에서 파베에서 조회한 데이터를 담을 프로퍼티
    var groupsData: [String:Any] = [:]
    var dataJSON: JSON = JSON.init(rawValue: [])!
    var groupList: GSGroupList?
    
    var selectLoaction: MTMapPoint?
    
    var userToken: String?
    // 로그인 유저뿐 아니라 비로그인 사용자도 관심사 선택시 값을가져야한다.
    var loginUserHobbyList: [String]?
    var userHobbyList: [String]?
    var userHobbyIndexPathList: [IndexPath]?
    var loadCurrentMapPoint: MTMapPoint?
    
    
    private var userLogtinState: Bool = false
    
    var scrollDraging: Bool = false
    var scrollStatePoiItem: MTMapPOIItem = MTMapPOIItem()
    
    /*******************************************/
    // MARK: -  IBOulet                        //
    /*******************************************/
    
    @IBOutlet weak var mapView: MTMapView!
    
    @IBOutlet weak var infoScrollView: UIScrollView!
    @IBOutlet weak var scrollAreaView: UIView!
    
    
    @IBOutlet weak var scrollAreaWidthConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var loginStatBtnOutlet: UIButton!
    @IBOutlet weak var groupCreateBtnOutlet: UIButton!
    @IBOutlet weak var locationDescriptionLable: UILabel!
    @IBOutlet weak var regionSelectBtnOutlet: UIButton!
    @IBOutlet weak var centerLogoImage: UIImageView!
    
    @IBOutlet weak var backgroundViewOutlet: UIView!
    
    
    /*******************************************/
    // MARK: -  Initialize                     //
    /*******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        infoScrollView.delegate = self
        infoScrollView.isPagingEnabled = true
        
        loginStatBtnOutlet.setTitleColor(#colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1), for: .normal)
        groupCreateBtnOutlet.setTitleColor(#colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1), for: .normal)
//        locationDescriptionLable.textColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
        regionSelectBtnOutlet.setTitleColor(#colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1), for: .normal)
        currentLocationAddress()
        
        self.applyGradient(withColours: [#colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.2984078323),#colorLiteral(red: 0.4745098039, green: 0.4745098039, blue: 0.4745098039, alpha: 0.6)], gradientOrientation: .horizontal, forView: backgroundViewOutlet)
        
        loginCheck()
        
        // 현위치 트랙킹 모드 On, 단말의 위치에 따라 지도 중심이 이동한다.
        mapView.currentLocationTrackingMode = .onWithoutHeading
        mapView.showCurrentLocationMarker = true
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        // 현위치를 표시하는 아이콘(마커)를 화면에 표시할지 여부를 설정한다.
        // currentLocationTrackingMode property를 이용하여 현위치 트래킹 기능을 On 시키면 자동으로 현위치 마커가 보여지게 된다.
        loadGroupListInfo(loadMapPoint: mapView.mapCenterPoint, hobbyList: userHobbyList ?? [])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        mapView.didReceiveMemoryWarning()
        
    }
    
    
    
    
    /****************************************************************************/
    // MARK: -  MTMapViewDelegate Method(Map View Event delegate methods)       //
    /****************************************************************************/
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
            
        }
        MTMapReverseGeoCoder.executeFindingAddress(for: mapPoint!, openAPIKey: "719b03dd28e6291a3486d538192dca4b", completionHandler: geoHandler)
        
        // #2. String? 을 리턴하는 MTMapReverseGeoCoder.findAddress 메서드를 통해 주소 형태 문자열을 반환 받아 사용
        let result = MTMapReverseGeoCoder.findAddress(for: mapPoint, withOpenAPIKey: "719b03dd28e6291a3486d538192dca4b") ?? ""
        
        // 서울 서초구 서초동 1328-10 => '서초구' 로 잘라야됨
        // components() 메서드사용하여 공백 기준으로 분리 => ["서울", "관악구", "신림동", "441-48"]
        // 우리가 필요한 값은 index 1번 값이 필요
        let addressSplitArr: [String] = result.components(separatedBy: " ")
        print(addressSplitArr)
        
        

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
    
    // 지도화면의 이동이 끝난뒤 호출
    // 플로우 확인해보니 최초에 맵이 뜨면서도 호출이 된다.
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        print("이동한 중심 좌표://", mapCenterPoint.mapPointGeo())
        
        // 스크롤 작동할 경우 loadGroupListInfo 호출을 하지 않기 위해 분기처리
        if self.scrollDraging == false {
            
            self.userStateMapLoad()
        }
    }
    
    func mapView(_ mapView: MTMapView!, dragStartedOn mapPoint: MTMapPoint!) {
        // 드래그가 끝이 나면 다시 맵뷰 이동에 따라 그룹정보를 가져오기 위해 scrollDraging의 값을 바꿔준다.
        self.scrollDraging = false
    }
    
    // 사용자가 지도 위 한지점을 터치하여 드래그를 끝낼 경우 호출
    func mapView(_ mapView: MTMapView!, dragEndedOn mapPoint: MTMapPoint!) {
        
    }
   
    
    /******************************************************************************/
    // MARK: -  MTMapViewDelegate Method(User Location Tracking delegate methods) //
    /******************************************************************************/
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
    
    func mapView(_ mapView: MTMapView!, zoomLevelChangedTo zoomLevel: MTMapZoomLevel) {
        print("변경된 줌레벨://", zoomLevel)
    }
    
    
    /******************************************************************************/
    // MARK: -  MTMapReverseGeoCoderDelegate Method                               //
    /******************************************************************************/
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, foundAddress addressString: String!) {
        
    }
    

    /**********************************************************/
    // MARK: -  UIScrollViewDelegate Method                   //
    /**********************************************************/
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.isDragging)
        if scrollView.isDragging {
            self.scrollDraging = true
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // 현재 스크롤의 targetContentOffset의 값을 이용하여 뷰 width를 나누어 index 생성
        let scrollViewIndex = Int(targetContentOffset.pointee.x/self.view.frame.size.width)
        //infoScrollView.contentOffset = targetContentOffset.pointee
        
        // index값을 가지고 해당하는 마커의 tag값읆 통해 누군지 찾는다.
        guard let scrollMapPoIItem = mapView.findPOIItem(byTag: scrollViewIndex) else {return}
        print("스크롤한 마커이름://",scrollMapPoIItem.itemName)
        print("스크롤한 마커 위.경도://",scrollMapPoIItem.mapPoint)
        

        
        // 찾은 마커를 select를 시켜준다.
        mapView.select(scrollMapPoIItem, animated: true)
        scrollStatePoiItem = scrollMapPoIItem
        print(self.infoScrollView.isDragging)
        // 맵의 이동시 호출 되는 메서드에서분기처리 할수있도록 프로퍼티 값을 할당
        if self.infoScrollView.isDragging == true {
            self.scrollDraging = true
        }
        
        mapView.setMapCenter(scrollMapPoIItem.mapPoint, animated: true)
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //mapView.deselect(scrollStatePoiItem)
        print(infoScrollView.isDragging)
    }
    
    
    
    /******************************************************************************/
    // MARK: -  GSSimpleGroupInfoProtocol Delegate Method                         //
    /******************************************************************************/
    // 커스텀뷰에서 탭 액션시 모임 정보뷰로 이동하기위해 viewcontroller가 해주어야 하는 부분이있어서 delegate 패턴으로 구현
    func nextViewPresent(nextView: JSGroupPagerTabViewController) {
        let nextNavi = UINavigationController(rootViewController: nextView)
        
        nextNavi.navigationBar.barTintColor = .black
        nextNavi.navigationBar.tintColor = .white
        
        self.present(nextNavi, animated: true, completion: nil)

    }
    
    
    /******************************************************************************/
    // MARK: -  GSCategoryProtocal Delegate Method                                //
    /******************************************************************************/
    // 관심정보뷰에서 관심사 선택후 클릭시 호출되는 메서드
    func selectCategory(categoryList: [String], categoryIndexPathList: [IndexPath]) {
        print("관심정보뷰에서 관심사 선택후 categoryIndexPathList://",categoryIndexPathList)
        
        var moveLocation: MTMapPoint = MTMapPoint()

        // 만약 현재 선택된 지역이 있으면 선택 지역의 mappoint를 할당
        // 그렇지 않으면 현위치의 지역의 mappoint를 할당
        if let location = self.selectLoaction {
            print("관심사 선택후 선택지역이 있을시 로케이션://", location.mapPointGeo())
            moveLocation = location
            mapView.setMapCenter(moveLocation, animated: true)
        }
        else{
            guard  let mappoint = self.loadCurrentMapPoint else { return }
            moveLocation = mappoint
            print("관심사 선택후 선택지역이 없을시 현재로케이션://", moveLocation.mapPointGeo())
        }
        print(moveLocation)
        
        
        self.userHobbyList = categoryList
        self.userHobbyIndexPathList = categoryIndexPathList
        
        // 사용자가 선택한 관심사와 관심사의 Indexpath 정보를 가져와 모임을 조회하는 메서드 파라미터에 담아 호출
        self.loadGroupListInfo(loadMapPoint: moveLocation, hobbyList: userHobbyList!)
        
    }
    // 지역선택뷰에서 지역 선택후 클릭시 호출되는 메서드
    func selectRegion(region: MTMapPoint?, regionName: String) {
        // 지역 정보를 옵셔널 체크하여 옵셔널일경우 현재 지도의 중심점으로 mapPoint를 할당
        if region != nil{
            self.selectLoaction = region
        }else{
            self.selectLoaction = mapView.mapCenterPoint
        }
        mapView.setMapCenter(selectLoaction, animated: true)
        // 지역선택 버튼 타이틀 부분을 현재 선택지역명으로 표시해준다.
        regionSelectBtnOutlet.titleLabel?.text = regionName
    }
    
    /******************************************************************************/
    // MARK: -  loginCompleteDelegate Method                                //
    /******************************************************************************/
    // JSLoginViewController에서 로그인이 성공하면 호출되는 메서드 - 프로토콜명 변경필요할듯
    func completeLogin() {
        loginCheck()
    }
    
    
    /*********************************************************/
    // MARK: -  Class  Method                                //
    /*********************************************************/
    // 메인뷰 상태 뷰 UI입히는 뷰
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation, forView: UIView) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = forView.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        
        forView.layer.insertSublayer(gradient, at: 0)
    }
    
    // 좌표값과 관심사 항목을 파라미터로 전달하여 주변 관심사 모임정보를 조회화여 마커를찍고 간단정보뷰를 그리는 메서드
    func loadGroupListInfo(loadMapPoint: MTMapPoint, hobbyList: [String]){
        GSDataCenter.shared.getLoadGroupMapList(token: "", latitude: loadMapPoint.mapPointGeo().latitude, longtitude: loadMapPoint.mapPointGeo().longitude, hobby: hobbyList) {[unowned self] (groupList) in
            
            print("API MAP list://", groupList)
            
            // 영역인컨텐츠뷰의 타입은 현재 UIView
            print("SCROLL AREAVIEW SUBVIEWS://", self.scrollAreaView.subviews,"/ COUNT:// ",self.scrollAreaView.subviews.count)
            // 호출되는 데이터에 따라 뷰를 새롭게 그려야한다. scrollAreaView(컨텐츠뷰)안에 그려진 뷰가 0가이상일경우 제거
            if self.scrollAreaView.subviews.count > 0 {
                self.scrollAreaView.removeSubviews()
            }
            self.mapView.removeAllPOIItems()
            var items = [MTMapPOIItem]()
           
            // 특정 마커에 대한 커스텀 적용시
            var count: CGFloat = 0
            var groupTagValue = 1
            var itmeTagValue = 0 // 간단정보뷰의 인덱스할당을 위한 변수
            for groupOne in groupList.groupOne {
                // 마커 생성 부분
                let interestPoitItem = MTMapPOIItem() // 마커 생성
                
                // 마커에 필요한 값을 groupOne에서 가져와서 할당
                let groupMapoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: groupOne.latitude, longitude: groupOne.longitude))
                interestPoitItem.itemName = String(groupOne.groupPK)
                interestPoitItem.mapPoint = groupMapoint
                
                // 마커의 디폴트 커스텀 이미지 할당
                interestPoitItem.customImage = #imageLiteral(resourceName: "BlackPinWithWhite")
                interestPoitItem.markerType = MTMapPOIItemMarkerType.customImage
                
                // 마커 선택시 커스텀 이미지 할당
                interestPoitItem.customSelectedImage = #imageLiteral(resourceName: "ColoredPinWithWhite")
                interestPoitItem.markerSelectedType = MTMapPOIItemMarkerSelectedType.customImage
                // 마커 애니메이션이 땅에서 올라오는 듯한 효과를 주도록 할당
                interestPoitItem.showAnimationType = MTMapPOIItemShowAnimationType.springFromGround
                interestPoitItem.tag = itmeTagValue
                items.append(interestPoitItem)
                itmeTagValue += 1
                
                
                // 이동하려는 모임이 무엇인지 구분짓기위해 GSSimpleGroupInfoView에 groupPK라는 String타입프로퍼티 선언하여 할당
                let simpleGroupInfoView: GSSimpleGroupInfoView = {
                    let view = GSSimpleGroupInfoView(
                        frame: CGRect(x: (self.view.bounds.size.width * count)+42,
                                      y: 0, width: self.view.bounds.size.width*0.8,
                                      height: self.infoScrollView.bounds.size.height))
                    view.delegate = self
                    view.groupPK = String(groupOne.groupPK)
                    view.groupName = groupOne.groupName
                    view.groupImage = groupOne.groupImg
                    view.groupInfo = groupOne.description
                    view.groupIndexs = "\(groupTagValue)."
                    return view
                }()
                
                self.scrollAreaView.addSubview(simpleGroupInfoView)
                simpleGroupInfoView.viewSetUp(groupImg: groupOne.groupImg, groupName: groupOne.groupName, groupSimpleInfo: groupOne.description, groupIndex: "\(groupTagValue).", currentView: self)
                count += 1
                groupTagValue += 1
                
                // ## 제약 사항 변경
                self.scrollAreaWidthConstraints.constant = self.infoScrollView.bounds.size.width*(count-1)
                // 뷰를 다시 그리는 메서드-적용된 제약사항을 가지고 새롭게 그리기만 하는 메서드이다.(viewDidLoad 등 다른 메서드와의 관계는 없다)
                self.infoScrollView.layoutIfNeeded()
                
            }
            self.mapView.addPOIItems(items)
        }
    }
    
    // 최초 로그인 체크
    func loginCheck(){
        // 토큰값과, 관심사 항목 옵셔널바이딩체크
        // 옵셔널이 아니면
        if let token = UserDefaults.standard.value(forKey: userDefaultsToken) as? String, let userHobbyList = UserDefaults.standard.value(forKey: "userHobby") as? [String] {
            self.userToken = token
            self.userHobbyList = userHobbyList
            self.loginStatBtnOutlet.setTitle("로그아웃", for: .normal)
            self.groupCreateBtnOutlet.isHidden = false
            self.userLogtinState = true
            //self.loadGroupListInfo(loadMapPoint: mapView.mapCenterPoint, hobbyList: userHobbyList)
            
        }else{
            print("LOGINCHECK NO LOGIN")
            self.loginStatBtnOutlet.setTitle("로그인", for: .normal)
            self.userToken = nil
            self.groupCreateBtnOutlet.isHidden = true
            self.userLogtinState = false
            self.userHobbyList = []
            self.userHobbyIndexPathList = []
            //self.loadGroupListInfo(loadMapPoint: mapView.mapCenterPoint, hobbyList: userHobbyList!)
            
        }
        self.loadGroupListInfo(loadMapPoint: mapView.mapCenterPoint, hobbyList: userHobbyList!)
        
    }
    
    // 현재 중심점위치의 지역의 동을 가져와서 지역선택 타이틀의 값을 바꿔주는 메서드
    func currentLocationAddress() {
        let result = MTMapReverseGeoCoder.findAddress(for: mapView.mapCenterPoint, withOpenAPIKey: "719b03dd28e6291a3486d538192dca4b") ?? "현재 위치를 알수없음"
        
        // 서울 서초구 서초동 1328-10 => '서초구' 로 잘라야됨
        // components() 메서드사용하여 공백 기준으로 분리 => ["서울", "관악구", "신림동", "441-48"]
        // 우리가 필요한 값은 index 1번 값이 필요
        let addressSplitArr: [String] = result.components(separatedBy: " ")
        guard let level2Name: String = addressSplitArr[2] else{return}
    
        DispatchQueue.main.async {
            self.regionSelectBtnOutlet.setTitle(level2Name, for: .normal)
        }
    }
    
    // 사용자의 현재 선택,상태의 할당된 정보로 관심모임정보를 호출하는 메서드
    func userStateMapLoad(){
        self.loadGroupListInfo(loadMapPoint: mapView.mapCenterPoint, hobbyList: userHobbyList!)
        currentLocationAddress()
    }
    
    
    /*********************************************************/
    // MARK: -  IBAction                                     //
    /*********************************************************/
    // 내 위치로 이동 액션
    @IBAction func myLocationBtnTouched(_ sender: UIButton){
        
        // 맵을 할당한 맵포인트 좌표로 이동- 예외처리필요(mapView자체가 nil)..
        guard let currentMapPoint = self.loadCurrentMapPoint else {
            print("내위치 이동중 좌표값이 nil발생")
            return
        }
        guard (mapView != nil) else {
            print("맵뷰기능을 사용할수없다")
            print(mapView.debugDescription)
            return
        }
        
        // MTMapView 기능 자체에서 수행을 하려면 info.plist에 privacy location부분을 Always로 변경필요
        mapView.setMapCenter(currentMapPoint, animated: true)
    }
    
    // 모임생성 버튼 액션
    @IBAction func groupCreateBtnTouched(_ sender: UIButton) {
        
        let storyBoard  = UIStoryboard.init(name: "JSGroupMain", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "JSCreateGroupViewController") as! JSCreateGroupViewController
        let navigation = UINavigationController(rootViewController: nextVC)
        self.present(navigation, animated: true, completion: nil)
        
        
    }
    
    // 로그인유무 상태 버튼 액션
    @IBAction func loginStateBtnTouched(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: userDefaultsToken) == nil {
            let storyBoard  = UIStoryboard.init(name: "JSGroupMain", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "JSLoginViewController") as! JSLoginViewController
            nextVC.loginDelegate = self
            self.present(nextVC, animated: true, completion: nil)
            
        }else{
            let header: HTTPHeaders = [
                "Auth":"Token \(UserDefaults.standard.value(forKey: userDefaultsToken) as! String)"
            ]
            
            Alamofire.request(
                URL(string: "\(rootDomain)/api/user/logout/")!,
                method: .post,
                headers: header)
                .responseJSON(completionHandler: {[unowned self] (response) in
                    guard response.result.isSuccess else{
                        print(response.result.error,"/", response.value)
                        return
                    }
                    
                    
                    UserDefaults.standard.removeObject(forKey: userDefaultsToken)
                    UserDefaults.standard.removeObject(forKey: userDefaultsPk)
                    UserDefaults.standard.removeObject(forKey: userDefaultsHobby)
                    
                    DispatchQueue.main.async {
                        print("로그아웃후 로그인 체크 호출")
                        self.loginCheck()
                    }
                })
            
        }
    }
    
    
    // 지역선택 버튼 액션
    @IBAction func regionSelectBtnTouched(_ sender: UIButton){
        let nextViewContorller = self.storyboard?.instantiateViewController(withIdentifier: "GSRegionCategoryView") as! GSRegionCategoryViewController
        nextViewContorller.categoryDelegate = self
        self.present(nextViewContorller, animated: true, completion: nil)
        
    }
    
    // 관심사버튼 액션
    @IBAction func categoryBtnTouched(_ sender: UIButton){
        let nextViewContorller = self.storyboard?.instantiateViewController(withIdentifier: "GSInterestCategoryView") as! GSInterestCategoryViewController
        nextViewContorller.categoryDelegate = self
        nextViewContorller.checkSelectedIndexPathArr = self.userHobbyIndexPathList ?? []
        
        // 로그인상태일때만 카테고리를 스트링 형태로 할당해준다.
        if self.userToken != nil {
            nextViewContorller.checkSelectedHobbyList = self.userHobbyList ?? []
        }
        self.present(nextViewContorller, animated: true, completion: nil)
        
    }

}


/*********************************************************/
// MARK: -  Extension                                    //
/*********************************************************/
// ScrollAreaView의 하위 뷰들의 정보를 초기화 하기위한 extension
// 참고: https://stackoverflow.com/questions/30831444/swift-remove-subviews-from-superview
extension UIView {
    
    // Recursive remove subviews and constraints
    func removeSubviews() {
        self.subviews.forEach({
            if !($0 is UILayoutSupport) {
                $0.removeSubviews()
                $0.removeFromSuperview()
            }
        })
        
    }
    
    // Recursive remove subviews and constraints
    func removeSubviewsAndConstraints() {
        self.subviews.forEach({
            $0.removeSubviewsAndConstraints()
            $0.removeConstraints($0.constraints)
            $0.removeFromSuperview()
        })
    }
    
}
