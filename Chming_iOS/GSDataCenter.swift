//
//  GSDataCenter.swift
//  Chming_iOS
//
//  Created by HwangGisu on 2017. 8. 4..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import Foundation
import Firebase

struct GSGroupOne {
    let groupPK:Int
    let latitude:Double
    let longitude:Double
    // latitude: 위도, longitude: 경도
    
    
    
}
struct GSGroupList {
    let interestCategory: eInterestCategory
    let interest: eInterest
    let groupOne: GSGroupOne
    
}

class GSDataCenter{
    static var shared: GSDataCenter = GSDataCenter()
    var tempdata: [String:Any] = ["강남구":[
                                            "group":[
                                                "축구":[
                                                        "22":[
                                                            "latitude":"37.517404",
                                                            "longtitude":"127.047446"
                                                        ],
                                                        "23":[
                                                            "latitude":"37.512128",
                                                            "longtitude":"127.0376503"
                                                        ]
                                                     ]
                                                ],
                                                "location":[
                                                            "latitude":"37.517404",
                                                            "longtitude":"127.047446"
                                                ]
                                        ]
                                ]
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
        var group = GSGroupOne(groupPK: 1, latitude: 1, longitude: 1)
        complition(group)
        
        
    }
    
    // 지역선택시 해당 정보리턴
    func selectLocalMapPoint(local: String) -> [String:Any] {
        print("선택 지역://", local)
        var localInfoDic: [String:Any] = [:]
        // 관심사 위치정보
        var interestMapPoint: MTMapPoint = MTMapPoint()
        // 해당 지역 위치정보
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
            let interestMap = localInterest?["축구"] as? [String:Any]
            var interestGroups: [[String: Any]] = []
            
            if let allKeys = interestMap?.keys {
            for key in allKeys{
                var gruopValue: [String:String] = interestMap![key] as! [String:String]
                var interestGroupOne: [String:Any] = [:]
                
                
                // MTMapPoint 타입으로 형변환을 위해 변수선언
                var groupLatitude = Double(gruopValue["latitude"]!) ?? 0.0
                let groupLongtitude = Double(gruopValue["longtitude"]!) ?? 0.0
                print("그룸 위도://", groupLatitude)
                print("그룸 경도://", groupLongtitude)
                
                let interestLocationMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: groupLatitude, longitude: groupLongtitude))!
                interestGroupOne.updateValue(key, forKey: "groupPK")
                interestGroupOne.updateValue(interestLocationMapPoint, forKey: "groupMapPoint")
                
                interestGroups.append(interestGroupOne)
                }
            }
            
            
            
//            interestMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(interestMap!["latitude"]!)!, longitude: Double(interestMap!["longtitude"]!)!))
            
            localInfoDic.updateValue(localMapPoint, forKey: "localMapPoint")
            localInfoDic.updateValue(interestGroups, forKey: "interestMapPoint")
        }
        return localInfoDic
        
    }
    
}
