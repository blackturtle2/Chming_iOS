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

// 그룹사용자
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

// 그룹
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

// 그룹 디테일정보
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
// 그룹 리스트
struct GSGroupList {
    let groupOne: [GSGroupOne]
    
    init(groups: JSON) {
        var groupList: [GSGroupOne] = []
        for group in groups{
            let groupOne = GSGroupOne(stringJSON: group)
            groupList.append(groupOne)
            
        }
        self.groupOne = groupList
    }
}

// 관심사 정보
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

// 관심사 정보 리스트
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

// 지역정보
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
// 지역 정보 리스트
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
// DataCenter
class GSDataCenter{
    // 싱글톤으로 구현
    static var shared: GSDataCenter = GSDataCenter()
    
    var groupListJSON: JSON = JSON.init(rawValue: [])!
    var groupDetailJSON: JSON = JSON.init(rawValue: [])!
    var hobbyListArr: [JSON] = []
    private init(){}
    
    // MARK: - API통신xAlamfire
    // 선택지역와 관심사를 가지고 그룹정보를 가져오는 메서드
    func getLoadGroupMapList(token: String, latitude: Double?, longtitude: Double?, hobby: [String]?, completion: @escaping (GSGroupList)->Void){
        let headerInfo: HTTPHeaders = [
            "Authorization":token
        ]
        
        var parameter: Parameters = Parameters()
        
        guard let hobbyList = hobby, let lat = latitude, let lng = longtitude else { return}
        switch hobbyList.count {
        case 0:
            print("case 0: \(hobbyList)")
            parameter = [
                "lat":lat,
                "lng":lng
            ]
        case 1:
            print("case 1: \(hobbyList)")
            parameter = [
                "lat":lat,
                "lng":lng,
                "hobby":hobbyList.first!
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
                "hobby":hobbyStr
                
            ]
        }
        
        Alamofire.request(
            URL(string: "http://chming.jeongmyeonghyeon.com/api/group/")!,
            method: .get,
            parameters: parameter, headers: headerInfo)
            .responseJSON {[unowned self] (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    return
                }
                let json = JSON(response.value as Any)
                self.groupListJSON = json
                print("데이터센터-현재  groupListJSON://",json)

                let groupList = GSGroupList(groups: self.groupListJSON)
                print("데이터센터-현재  Struct GROUPLIST://",groupList)
                completion(groupList)
        }
    }
    
    
    // 그룹의 상세정보를 조회하는 메서드
    func getGroupDetail(groupPK: Int, completion:@escaping (GSGroupDetail)->Void){
       
        
        Alamofire.request(
            URL(string: "http://chming.jeongmyeonghyeon.com/api/group/\(groupPK)")!,
            method: .get)
            .responseJSON {[unowned self] (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    return
                }
                let json = JSON(response.value as Any)
                self.groupDetailJSON = json
                print("GROUPDETAIL INFO:// ",self.groupDetailJSON)
                print(self.groupDetailJSON["name"])
                
                let groupDetail = GSGroupDetail(jsonData: self.groupDetailJSON)
                print("GSGROUPDETAIL://",groupDetail)

                completion(groupDetail)
        }
    }
    
    // 관심사 정보를 조회하는 메서드
    func getCategoryHobbyList(completion:@escaping ([GSHobbyCateogrySortingList])->Void){
        Alamofire.request(
            URL(string: "http://chming.jeongmyeonghyeon.com/api/group/hobby/")!,
            method: .get)
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    return
                }
                let json = JSON(response.value as Any)
                let hobbyListJSON = json
                
                // 관심사 카테고리 값을 가지고 중복제거 하여 배열에 할당
                var categoryArr: [String] = []
                for hobby in hobbyListJSON.arrayValue{
                    let cateogry = hobby["category"].stringValue
                    if categoryArr.contains(cateogry) == false{
                        categoryArr.append(cateogry)
                    }
                }
                
                // 중족제거된 관심사 카테고리를 비교하여 같은 카테고리의 관심사들로 데이터 구성
                var categoryData: [GSHobbyCateogrySortingList] = []
                for category in categoryArr {
                    categoryData.append(GSHobbyCateogrySortingList(category: category, hobbyListArr: hobbyListJSON.arrayValue))
                }
                completion(categoryData)
        }

    }
    
    // 지역정보 조회 메서드
    func getCategoryRegionList(completion:@escaping ([GSRegionCategorySortingList])->Void){
        Alamofire.request(
            URL(string: "http://chming.jeongmyeonghyeon.com/api/group/region/")!,
            method: .get)
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    return
                }
                let json = JSON(response.value as Any)
                let regionListJson = json
                print("getCategoryRegionList INFO:// ", regionListJson)
                
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

                completion(categoryData)
        }
        
    }
    
    // 현재 중심점위치의 지역의 동을 가져와서 지역선택 타이틀의 값을 바꿔주는 메서드
    func currentLocationFullAddress(mapPoint: MTMapPoint) -> String{
        let result = MTMapReverseGeoCoder.findAddress(for: mapPoint, withOpenAPIKey: "719b03dd28e6291a3486d538192dca4b") ?? ""
        
        // 서울 서초구 서초동 1328-10 => '서초구' 로 잘라야됨
        // components() 메서드사용하여 공백 기준으로 분리 => ["서울", "관악구", "신림동", "441-48"]
        // 우리가 필요한 값은 index 1번 값이 필요
        return result
        
    }

}
