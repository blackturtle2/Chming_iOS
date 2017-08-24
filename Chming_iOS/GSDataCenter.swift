//
//  GSDataCenter.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import Foundation
import Firebase
import Alamofire
import SwiftyJSON

struct GSGroupUser{
    let userPK: Int
    let profileImg: String?
    let userName: String
    
    init(authorJson: [String : JSON]) {
        print("STRUCT authorJson://", authorJson)
        self.userPK = authorJson["pk"]?.intValue ?? 0
        self.profileImg = authorJson["profile_img"]?.string
        self.userName = authorJson["username"]?.stringValue ?? ""
    }
}
//struct GSGroupOne {
//    let groupPK: Int
//    let groupHobby: String
//    let latitude: Double
//    let longitude: Double
//    // latitude: 위도, longitude: 경도
//
//    init(stringJSON: (String,JSON)) {
//        self.groupPK = stringJSON.1["pk"].intValue
//        self.groupHobby = stringJSON.1["hobby"].stringValue
//        self.latitude = stringJSON.1["lat"].doubleValue
//        self.longitude = stringJSON.1["lng"].doubleValue
//    }
//    
//}
struct GSGroupOne {
    let groupPK: Int
    let groupHobby: [JSON]
    let groupName: String
    let groupImg: String
    let description: String
    let address: String
    let latitude: Double
    let longitude: Double
    let author: GSGroupUser
    let memberCount: Int
    let likeUserCount: Int
    // latitude: 위도, longitude: 경도
    
    init(stringJSON: (String,JSON)) {
        self.groupPK = stringJSON.1["pk"].intValue
        self.groupHobby = stringJSON.1["hobby"].arrayValue
        self.latitude = stringJSON.1["lat"].doubleValue
        self.longitude = stringJSON.1["lng"].doubleValue
        self.groupName = stringJSON.1["name"].stringValue
        self.groupImg = stringJSON.1["image"].stringValue
        self.description = stringJSON.1["description"].stringValue
        self.address = stringJSON.1["address"].stringValue
        self.author = GSGroupUser(authorJson: stringJSON.1["author"].dictionaryValue)
        self.memberCount = stringJSON.1["member_count"].intValue
        self.likeUserCount = stringJSON.1["like_user_count"].intValue
    }
    
}
struct GSGroupDetail {
    let groupPK: Int
    let hobby: [JSON]
    let groupName: String
    let image: String
    let description: String
    let address: String
    let lat: Double
    let lng: Double
    let author: GSGroupUser
    let memberCount: Int
    
    init(jsonData: JSON) {
        
        self.groupPK = jsonData["pk"].intValue
        self.hobby = jsonData["hobby"].arrayValue
        self.groupName = jsonData["name"].stringValue
        self.image = jsonData["image"].stringValue
        self.description = jsonData["description"].stringValue
        self.address = jsonData["address"].stringValue
        self.lat = jsonData["lat"].doubleValue
        self.lng = jsonData["lng"].doubleValue
        self.author = GSGroupUser(authorJson: jsonData["author"].dictionaryValue)
        self.memberCount = jsonData["member_count"].intValue
        
    }
}
struct GSGroupList {
//    let interestCategory: eInterestCategory
//    let interest: eInterest
    let groupOne: [GSGroupOne]
    
    init(groups: JSON) {
//        self.groupOne = [GSGroupOne(groupJson: groups)]
        var groupList: [GSGroupOne] = []
        for group in groups{
            let groupOne = GSGroupOne(stringJSON: group)
            groupList.append(groupOne)
            
        }
        self.groupOne = groupList
    }
}

struct GSHobby {
    let hobbyPK: Int
    let category: String
    let categoryDetail: String
    
    init(hobbyListJSON: JSON) {
        self.hobbyPK = hobbyListJSON["pk"].intValue
        self.category = hobbyListJSON["category"].stringValue
        self.categoryDetail = hobbyListJSON["category_detail"].stringValue
    }
}

struct GSHobbyCateogrySortingList{
    let category: String
    let sortingData: [GSHobby]
    
    init(category: String, hobbyListArr: [JSON]) {
        var hobbyData: [GSHobby] = []
        for hobby in hobbyListArr{
            if hobby["category"].stringValue == category{
                hobbyData.append(GSHobby(hobbyListJSON: hobby))
            }
        }
        self.category = category
        self.sortingData = hobbyData
    }
    
}

struct GSRegion {
    let regionPK: Int
    let si: String
    let gu: String
    let dong: String
    let lat: Double
    let lng: Double
    init(regionListJSON: JSON) {
        self.regionPK = regionListJSON["pk"].intValue
        self.si = regionListJSON["si"].stringValue
        self.gu = regionListJSON["level1"].stringValue
        self.dong = regionListJSON["level2"].stringValue
        self.lat = regionListJSON["lat"].doubleValue
        self.lng = regionListJSON["lng"].doubleValue
    }
    
}
// 기존 "gu","dong" => "level1", "level2"로 변경
struct  GSRegionCategorySortingList {
    let category: String
    let sortingData: [GSRegion]
    
    init(category: String, regionListArr: [JSON]) {
        var regionData: [GSRegion] = []
        for region in regionListArr {
            if region["level1"].stringValue == category{
                regionData.append(GSRegion(regionListJSON: region))
            }
        }
        self.category = category
        self.sortingData = regionData
    }
}
class GSDataCenter{
    static var shared: GSDataCenter = GSDataCenter()
    var tempdata: [String:Any] = ["강남구":[
                                        "group":[
                                            "축구":[
                                                "22":[
                                                    "latitude":"37.514537",
                                                    "longtitude":"127.046695",
                                                    "groupName":"FC강남 싸카"
                                                    
                                                ],
                                                "23":[
                                                    "latitude":"37.512128",
                                                    "longtitude":"127.0376503"
                                                ]
                                                
                                             ],
                                            "농구":[
                                                "30":[
                                                    "latitude":"37.5172849",
                                                    "longtitude":"127.047120"
                                                ],
                                                "31":[
                                                    "latitude":"37.512662",
                                                    "longtitude":"127.036938"
                                                ]
                                                
                                             ]
                                          ],
                                         "location":[
                                                    "latitude":"37.517404",
                                                    "longtitude":"127.047446"
                                          ]
                                   ],
                                  "서초구":[
                                    "group":[
                                        "축구":[
                                            "25":[
                                                "latitude":"37.48744",
                                                "longtitude":"127.036240"
                                            ],
                                            "27":[
                                                "latitude":"37.485991",
                                                "longtitude":"127.027997"
                                            ]
                                            
                                        ],
                                        "농구":[
                                            "34":[
                                                "latitude":"37.481153",
                                                "longtitude":"127.039059"
                                            ],
                                            "36":[
                                                "latitude":"37.484272",
                                                "longtitude":"127.030093"
                                            ]
                                            
                                        ]
                                    ],
                                         "location":[
                                            "latitude":"37.4819815",
                                            "longtitude":"127.0272152"
                                         ]
                                   ],
                                  "중구":[
                                    "group":[
                                        "축구":[
                                            "40":[
                                                "latitude":"37.557802",
                                                "longtitude":"126.972420"
                                            ],
                                            "41":[
                                                "latitude":"37.559295",
                                                "longtitude":"126.972500"
                                            ]
                                        ]
                                    ],
                                    "location":[
                                        "latitude":"37.4819815",
                                        "longtitude":"127.0272152"
                                    ]
        ]

        
                                ]
    
    
    // 불필요 삭제예정-0817
    var groupListJSON: JSON = JSON.init(rawValue: [])!
    var groupDetailJSON: JSON = JSON.init(rawValue: [])!
    var hobbyListArr: [JSON] = []
    private init(){}
    
    // 좌표값을 파라미터, 관심사 를 받아서 주변 모임리스트를 리턴
    // 일단은 좌표값을 가지고 구현
    
    func loadGroup(mapPoint: MTMapPoint, complition: (GSGroupOne) ->Void){
        // 먼저 좌표값을 가지고 파베 기준으로 주소형태로 변환
        
        guard let fullAddress = MTMapReverseGeoCoder.findAddress(for: mapPoint, withOpenAPIKey: "api_key")else {return }
        
        //가져온 전체 주소에서 '구'부분을 문자열 자르기 - " "공백 기준으로
        let adressArr = fullAddress.components(separatedBy: " ")
        let guAddress = adressArr[1]
        Database.database().reference().child("GroupListMap").child(guAddress).observeSingleEvent(of: .value, with: { (dataSnapShot) in
            let groupListDict = dataSnapShot.value as! [String:Any]
            print("파이어베이스 데이터:// ", groupListDict)
            
            
        })
        //
        //var group = GSGroupOne(groupPK: 1, latitude: 1, longitude: 1)
        //complition(group)
        
        
    }
    
    // 임시데이터 - 지역선택시 선택지역 정보리턴
    func selectLocalMapPoint(local: String) -> [String:Any] {
        print("선택 지역://", local)
        var localInfoDic: [String:Any] = [:]
        // 관심사 모임의 위치정보
        var interestMapPoint: MTMapPoint = MTMapPoint()
        // 선택 지역 위치정보
        var localMapPoint: MTMapPoint = MTMapPoint()
        if let data = tempdata[local] as? [String:Any] {
            // 선택지역 location 정보
            let localMap = data["location"] as? [String:String] ?? [:]
            let latitudeStr = localMap["latitude"]!
            let longtitudeStr = localMap["longtitude"]!
            let latitude = Double(latitudeStr) ?? 0.0
            let longtitude = Double(longtitudeStr) ?? 0.0
            print(Double(latitude))
            print(Double(longtitude))
            
            // 선택지역 위도,경도 정보
            localMapPoint =  MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longtitude))
            print(localMapPoint)
            
            // 관심사 모임 정보
//            let localInterest = data["group"] as? [String:Any]
//            let interestMap = localInterest?["축구"] as? [String:Any]
//            var interestGroups: [[String: Any]] = []
//            interestMap?.forEach({ (key, value) in
//                var gruopValue: [String:String] = value as! [String:String]
//                var interestGroupOne: [String:Any] = [:]
//                
//                
//                // MTMapPoint 타입으로 형변환을 위해 변수선언
//                var groupLatitude = Double(gruopValue["latitude"]!) ?? 0.0
//                let groupLongtitude = Double(gruopValue["longtitude"]!) ?? 0.0
//                let interestLocationMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: groupLatitude, longitude: groupLongtitude))!
//                interestGroupOne.updateValue(key, forKey: "groupPK")
//                interestGroupOne.updateValue(interestLocationMapPoint, forKey: "groupMapPoint")
//            
//                interestGroups.append(interestGroupOne)
//            })
            
            
            // 관심사 모임 정보
            let localInterest = data["group"] as? [String:Any]
            // 선택지역의 모든 관심사 모임 정보를 담을 프로퍼티
            var interestAllGroups: [String:Any] = [:]
            if let localInterestKeys = localInterest?.keys{
                for interestKey in localInterestKeys{
                    var interestMaps = localInterest?[interestKey] as! [String:Any]
                    // 모임명 키값의 정보들
                    //예시) "축구"라는 키값의 모든 값들 => ["22": ["latitude": "37.517404", "longtitude": "127.047446"], "23": ["latitude": "37.512128", "longtitude": "127.0376503"]]
                    print("모임리스트 정보://", interestMaps)
                    //[ "22": ["latitude": "37.517404", "longtitude": "127.047446"], 
                    //  "23": ["latitude": "37.512128", "longtitude": "127.0376503"]]
                    print("key값://", interestKey) // 축구
                    
                    var interestGroups: [[String: Any]] = []
                    for groupKey in interestMaps.keys {
                        var groupValue = interestMaps[groupKey] as! [String:String]
                        print(groupValue)
                        var interestGroupOneInfo: [String:Any] = [:]
                        
                        // MTMapPoint 타입으로 형변환을 위해 변수선언
                        var groupLatitude = Double(groupValue["latitude"]!) ?? 0.0
                        let groupLongtitude = Double(groupValue["longtitude"]!) ?? 0.0
                        print("그룸 tt위도://", groupLatitude)
                        print("그룸 tt경도://", groupLongtitude)
                        
                        let interestLocationMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: groupLatitude, longitude: groupLongtitude))!
                        interestGroupOneInfo.updateValue(groupKey, forKey: "groupPK")
                        interestGroupOneInfo.updateValue(interestLocationMapPoint, forKey: "groupMapPoint")
                        
                        interestGroups.append(interestGroupOneInfo)
                        
                    }
                    interestAllGroups.updateValue(interestGroups, forKey: interestKey)
                }
                print("여러 관심모임정보 토랄://", interestAllGroups)
                localInfoDic.updateValue(localMapPoint, forKey: "localMapPoint")
                localInfoDic.updateValue(interestAllGroups, forKey: "interestMapPoint")
                 print("리턴 여러 관심모임정보 토랄://", localInfoDic)
            }
            
            // ----------------------------------------------------------//
//            let interestMap = localInterest?["축구"] as? [String:Any]
//            var interestGroups: [[String: Any]] = []
//            
//            if let allKeys = interestMap?.keys {
//            for key in allKeys{
//                var gruopValue: [String:String] = interestMap![key] as! [String:String]
//                var interestGroupOne: [String:Any] = [:]
//                
//                
//                // MTMapPoint 타입으로 형변환을 위해 변수선언
//                var groupLatitude = Double(gruopValue["latitude"]!) ?? 0.0
//                let groupLongtitude = Double(gruopValue["longtitude"]!) ?? 0.0
//                print("그룸 위도://", groupLatitude)
//                print("그룸 경도://", groupLongtitude)
//                
//                let interestLocationMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: groupLatitude, longitude: groupLongtitude))!
//                interestGroupOne.updateValue(key, forKey: "groupPK")
//                interestGroupOne.updateValue(interestLocationMapPoint, forKey: "groupMapPoint")
//                
//                interestGroups.append(interestGroupOne)
//                }
//            }
//            print("INTERESTGROUPS://", interestGroups)
//            
//            
//            
////            interestMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(interestMap!["latitude"]!)!, longitude: Double(interestMap!["longtitude"]!)!))
//            
//            localInfoDic.updateValue(localMapPoint, forKey: "localMapPoint")
//            localInfoDic.updateValue(interestGroups, forKey: "interestMapPoint")
        }
        //-----------------------------------------------------------
        return localInfoDic
        
    }
    
    
    // 지역선택시 선택지역 정보리턴 - 파베임...클로저 사용해야될듯합니다. 혼술 연습햇던거 봐보자..추가 적으로 파베구조장 Group디비에 지역이 필요하여 리턴시 추가
    func selectLocalMapPointFirebaseTest(local: String, completion:@escaping ([String:Any])->Void) {
        print("선택 지역://", local)
        var localInfoDic: [String:Any] = [:]
        // 관심사 모임의 위치정보
        var interestMapPoint: MTMapPoint = MTMapPoint()
        // 선택 지역 위치정보
        var localMapPoint: MTMapPoint = MTMapPoint()
        
//---- 파베 데이터를 가져와보자
        Database.database().reference().child("GroupListMap").child(local).observeSingleEvent(of: .value, with: { (dataSnapShot) in
                let groupListDict = dataSnapShot.value as! [String:Any]
                print(groupListDict)
                print("FIREBase-groupListDict://", groupListDict)
                // 선택지역 location 정보
                
                let localMap = groupListDict["location"] as! [String:Any]
                // # FireBase database에 오타잇음 ==> 수정필요합니다.=> 고쳣습니다.
                let latitude = localMap["latitude"] as! Double
                let longtitude = localMap["longtitude"] as! Double
                
                print(latitude)
                print(longtitude)
                
                // 선택지역 위도,경도 정보
                localMapPoint =  MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longtitude))
                print(localMapPoint)
                
                // 관심사 모임 정보
                let localInterest = groupListDict["groupList"] as! [String:Any]
                print("count://", localInterest.count)
                print("data://",localInterest)
                // 선택지역의 모든 관심사 모임 정보를 담을 프로퍼티
                var interestAllGroups: [String:Any] = [:]
                
                for interestKey in localInterest{
                    print("Firebase== 제발://",interestKey.key)
                    print(localInterest["축구"])
                    var interestMaps = localInterest[interestKey.key] as! [String:Any]
                    // 모임명 키값의 정보들
                    //예시) "축구"라는 키값의 모든 값들 => ["22": ["latitude": "37.517404", "longtitude": "127.047446"], "23": ["latitude": "37.512128", "longtitude": "127.0376503"]]
                    print("FIREBase-모임리스트 정보://", interestMaps)
                    //[ "22": ["latitude": "37.517404", "longtitude": "127.047446"],
                    //  "23": ["latitude": "37.512128", "longtitude": "127.0376503"]]
                    print("FIREBase-key값://", interestKey) // 축구
                    
                    var interestGroups: [[String: Any]] = []
                    for groupKey in interestMaps.keys {
                        var groupValue = interestMaps[groupKey] as! [String:Any]
                        print(groupValue)
                        var interestGroupOneInfo: [String:Any] = [:]
                        
                        // MTMapPoint 타입으로 형변환을 위해 변수선언
                        var groupLatitude = groupValue["latitude"] as! Double ?? 0.0
                        let groupLongtitude = groupValue["longtitude"] as! Double ?? 0.0
                        print("FIREBase-그룸 tt위도://", groupLatitude)
                        print("FIREBase-그룸 tt경도://", groupLongtitude)
                        
                        let interestLocationMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: groupLatitude, longitude: groupLongtitude))!
                        interestGroupOneInfo.updateValue(groupKey, forKey: "groupPK")
                        interestGroupOneInfo.updateValue(interestLocationMapPoint, forKey: "groupMapPoint")
                        
                        interestGroups.append(interestGroupOneInfo)
                        
                    }
                    interestAllGroups.updateValue(interestGroups, forKey: interestKey.key)
                }
                print("여러 관심모임정보 토랄://", interestAllGroups)
                localInfoDic.updateValue(localMapPoint, forKey: "localMapPoint")
                localInfoDic.updateValue(interestAllGroups, forKey: "interestMapPoint")
                localInfoDic.updateValue(local, forKey: "local")
                print("리턴 여러 관심모임정보 토랄://", localInfoDic)
                completion(localInfoDic)
            }
        )
    }
    
    
    // MARK: - Firebase 기반 조회 메서드 부분
    func groupInfoLoad(local:String, interestKey: String, groupPK: String, complition: @escaping ([String:Any]) ->Void){
        // 먼저 좌표값을 가지고 파베 기준으로 주소형태로 변환
        print("로컬://", local)
        print("카테고리 키 ://", interestKey)
        
        
        Database.database().reference().child("Group").child(local).child(interestKey).child(groupPK).observeSingleEvent(of: .value, with: { (dataSnapShot) in
            print("데이터스냅샷://",dataSnapShot.value)
            let groupListDict = dataSnapShot.value as! [String:Any]
//            print("선택 관심사의 모임 정보 데이터:// ", groupListDict)
            
            
            complition(groupListDict)
        })
    }
    
    // MARK: - API통신xAlamfire
    func getLoadGroupMapList(token: String, latitude: Double?, longtitude: Double?, hobby: [String]?, distancelimit:MTMapZoomLevel? = 2 , completion: @escaping (GSGroupList)->Void){
        let headerInfo: HTTPHeaders = [
            "Authorization":token
        ]
        
        var parameter: Parameters = Parameters()
//        if hobby?.count == 0{
//             parameter = [
//                "lat":latitude,
//                "lng":longtitude
//            ]
//        }else{
//            let hobbyes: String = ""
//            for hobbyStr in hobby!{
//                
//                hobbyes.appending(hobbyStr)
//                
//            }
//            parameter = [
//                "lat":latitude,
//                "lng":longtitude
//            ]
//        }
        
        guard let hobbyList = hobby, let lat = latitude, let lng = longtitude, let distancelimit = distancelimit else { return}
        var radius: Double = 1000
        if distancelimit <= 1 {
            radius = 0.5
        }else if distancelimit == 2{
            radius = 1.0
        }else{
            radius = 1.5
        }
        switch hobbyList.count {
        case 0:
            print("case 0: \(hobbyList)")
            parameter = [
                "lat":lat,
                "lng":lng,
                "distance_limit":radius
            ]
        case 1:
            print("case 1: \(hobbyList)")
            parameter = [
                "lat":lat,
                "lng":lng,
                "hobby":hobbyList.first!,
                "distance_limit":radius
            ]
        default:
            print("default: \(hobbyList)")
            var hobbyStr = ""
            for hobbyIndex in 0...hobbyList.count-1{
                if hobbyIndex != hobbyList.count-1{
                    hobbyStr.append("\(hobbyList[hobbyIndex]),")
                }else{
                    hobbyStr.append("\(hobbyList[hobbyIndex])")
                }
            }
            print("default hobbyStr://", hobbyStr)
            parameter = [
                "lat":lat,
                "lng":lng,
                "hobby":hobbyStr,
                "distance_limit":radius
                
            ]
        }
        
        print("데이터센터-현재 위도 경도://",latitude,"/",longtitude)
        print("데이터센터 조회 파라미터://",parameter)
        Alamofire.request(
            URL(string: "http://chming.jeongmyeonghyeon.com/api/group/")!,
            method: .get,
            parameters: parameter, headers: headerInfo)
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    return
                }
                let json = JSON(response.value)
                self.groupListJSON = json
                print("데이터센터-현재  groupListJSON://",json)
                var groups: [GSGroupOne] = []
//                for data in self.groupListJSON {
//                    print("",data)
//                    print("Data:// ",data.1["pk"].stringValue)
//                    let groupOne = GSGroupOne(groupPK: data.1["pk"].intValue, groupHobby: data.1["hobby"].stringValue, latitude: data.1["lat"].doubleValue, longitude: data.1["lng"].doubleValue)
//                    print(groupOne)
//                    groups.append(groupOne)
//                    
//                    
//                }
                let groupList = GSGroupList(groups: self.groupListJSON)
                print("데이터센터-현재  Struct GROUPLIST://",groupList)
                completion(groupList)
        }
    }
    
    func getGroupDetail(groupPK: Int, completion:@escaping (GSGroupDetail)->Void){
       
        
        Alamofire.request(
            URL(string: "http://chming.jeongmyeonghyeon.com/api/group/\(groupPK)")!,
            method: .get)
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    return
                }
                let json = JSON(response.value)
                self.groupDetailJSON = json
                print("GROUPDETAIL INFO:// ",self.groupDetailJSON)
                print(self.groupDetailJSON["name"])
                
                let groupDetail = GSGroupDetail(jsonData: self.groupDetailJSON)
                print("GSGROUPDETAIL://",groupDetail)
//                for data in self.dataJSON {
//                    print("Data:// ",data.1["pk"].stringValue)
//                    let groupOne = GSGroupOne(groupPK: data.1["pk"].intValue, groupHobby: data.1["hobby"].stringValue, latitude: data.1["lat"].doubleValue, longitude: data.1["lng"].doubleValue)
//                    print(groupOne)
//                    groups.append(groupOne)
//                }
//                let groupList = GSGroupList(groupOne: groups)
                completion(groupDetail)
        }
    }
    
    func getCategoryHobbyList(completion:@escaping ([GSHobbyCateogrySortingList])->Void){
        Alamofire.request(
            URL(string: "http://chming.jeongmyeonghyeon.com/api/group/hobby/")!,
            method: .get)
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    return
                }
                let json = JSON(response.value)
                let hobbyListJSON = json
                print("getHobbyList INFO:// ", hobbyListJSON)
//________________________TEST___________________
//                let hobbySortingList = GSSortHobbyList(hobbyListJSON: hobbyListJSON)
//                
//                
//                let hobbyListArr = hobbyListJSON.arrayValue
//                
//
//                print("HOBBY ARR://",hobbyListArr)
//                
//                
//                print("HOBBY sortHobbyDic://", hobbySortingList)
//________________________TEST___________________
                
                // array map을 쓰면 줄일수 잇을것 같다 -  Set으로 구현하였으나 순서가 없어서 보류중
//                var categorySet: Set<String> = []
//                let categoryArray = hobbyListJSON.arrayValue.map({ (hobbyJson) -> String in
//                    return hobbyJson["category"].stringValue
//                })
//                categorySet = Set(categoryArray)
//               
//                print("categorySet://",categorySet)
//                print("categorySet://",categorySet)
//                print("categorySet://",categorySet)
                
                var categoryArr: [String] = []
                for hobby in hobbyListJSON.arrayValue{
                    let cateogry = hobby["category"].stringValue
                    if categoryArr.contains(cateogry) == false{
                        categoryArr.append(cateogry)
                    }
                }
                
                var categoryData: [GSHobbyCateogrySortingList] = []
                for category in categoryArr {
                    categoryData.append(GSHobbyCateogrySortingList(category: category, hobbyListArr: hobbyListJSON.arrayValue))
                }
                print("CATEGORY Data://", categoryData)
                

                
                completion(categoryData)
        }

    }
    
    
    func getCategoryRegionList(completion:@escaping ([GSRegionCategorySortingList])->Void){
        Alamofire.request(
            URL(string: "http://chming.jeongmyeonghyeon.com/api/group/region/")!,
            method: .get)
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    return
                }
                let json = JSON(response.value)
                let regionListJson = json
                print("getCategoryRegionList INFO:// ", regionListJson)
                //________________________TEST___________________
                //                let hobbySortingList = GSSortHobbyList(hobbyListJSON: hobbyListJSON)
                //
                //
                //                let hobbyListArr = hobbyListJSON.arrayValue
                //
                //
                //                print("HOBBY ARR://",hobbyListArr)
                //
                //
                //                print("HOBBY sortHobbyDic://", hobbySortingList)
                //________________________TEST___________________
                
                // array map을 쓰면 줄일수 잇을것 같다 -  Set으로 구현하였으나 순서가 없어서 보류중
                //                var categorySet: Set<String> = []
                //                let categoryArray = hobbyListJSON.arrayValue.map({ (hobbyJson) -> String in
                //                    return hobbyJson["category"].stringValue
                //                })
                //                categorySet = Set(categoryArray)
                //
                //                print("categorySet://",categorySet)
                //                print("categorySet://",categorySet)
                //                print("categorySet://",categorySet)
                
                
                // 기존 "gu", "dong" 필드로 level1, level2로 변경(0823)
                var categoryArr: [String] = []
                for hobby in regionListJson.arrayValue{
                    let cateogry = hobby["level1"].stringValue
                    if categoryArr.contains(cateogry) == false{
                        categoryArr.append(cateogry)
                    }
                }
                
                var categoryData: [GSRegionCategorySortingList] = []
                for category in categoryArr {
                    categoryData.append(GSRegionCategorySortingList(category: category, regionListArr:regionListJson.arrayValue))
                }
                print("CATEGORY Data://", categoryData)
                
                
                
                completion(categoryData)
        }
        
    }
    
    // 현재 중심점위치의 지역의 동을 가져와서 지역선택 타이틀의 값을 바꿔주는 메서드
    func currentLocationFullAddress(mapPoint: MTMapPoint) -> String{
        let result = MTMapReverseGeoCoder.findAddress(for: mapPoint, withOpenAPIKey: "719b03dd28e6291a3486d538192dca4b") ?? ""
        
        print("//@@@@@@@@@@ FindAddress Start @@@@@@@@@@ //")
        print("FindAddress: // ", result)
        print("//@@@@@@@@@@ FindAddress End @@@@@@@@@@ //")
        
        // 서울 서초구 서초동 1328-10 => '서초구' 로 잘라야됨
        // components() 메서드사용하여 공백 기준으로 분리 => ["서울", "관악구", "신림동", "441-48"]
        // 우리가 필요한 값은 index 1번 값이 필요
        return result
        
    }

}
