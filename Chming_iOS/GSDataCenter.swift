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
                                            "group":["축구":[
                                                            "latitude":"37.517404",
                                                            "longtitude":"127.047446"]
                                                            ],
                                            "location":[
                                                        "latitude":"37.517404",
                                                        "longtitude":"127.047446"]
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
    func selectLocalMapPoint(local: String) -> [String:MTMapPoint] {
        print("선택 지역://", local)
        var localInfoDic: [String:MTMapPoint] = [:]
        // 관심사 위치정보
        var interestMapPoint: MTMapPoint = MTMapPoint()
        // 해당 지역 위치정보
        var localMapPoint: MTMapPoint = MTMapPoint()
        if let data = tempdata[local] as? [String:Any] {
            let localMap = data["location"] as? [String:String] ?? [:]
            let latitudeStr = localMap["latitude"]!
            let longtitudeStr = localMap["longtitude"]!
            let latitude = Double(latitudeStr) ?? 0.0
            let longtitude = Double(longtitudeStr) ?? 0.0
            print(Double(latitude))
            print(Double(longtitude))
            
            localMapPoint =  MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longtitude))
            print(localMapPoint)
            // 관심사의 정보 필요시
            let localInterest = data["group"] as? [String:Any]
            let interestMap = localInterest?["축구"] as? [String:String]
            interestMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(interestMap!["latitude"]!)!, longitude: Double(interestMap!["longtitude"]!)!))
            
            localInfoDic.updateValue(localMapPoint, forKey: "localMapPoint")
            localInfoDic.updateValue(interestMapPoint, forKey: "interestMapPoint")
        }
        return localInfoDic
        
    }
    
}
