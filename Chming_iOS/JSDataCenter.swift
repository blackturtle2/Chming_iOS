//
//  JSDataCenter.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 8..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import Foundation

struct JSGroupInfo {
    let name: String
    
    let mainImageUrl: String?
    let mainText: String?
    
    // "모임 공지 사항 리스트" 프로퍼티
    
    let leaderPK: Int
    let leaderName: String
    let memberList: [String] = []
    
    let location: eLocalList
    let interestCategory: eInterestCategory
    let interest: eInterest
    
    let address: String
    let longitude: Double
    let latitude: Double
}


class JSDataCenter {
    
    static let shared = JSDataCenter()
    
    var selectedGroupPK:Int?
    
    init() {
        self.selectedGroupPK = nil
    }
    
    // groupPK를 넣으면, JSGroupInfo 형태로 리턴하는 메소드입니다.
    // 일단, 임시 데이터이고, 추후 여기에서 통신이 이루어질 예정입니다.
    // GroupInfoViewController에서 이 값들을 받아서 UI에 뿌릴 예정입니다.
    func findGroupInfo(ofGroupPK:Int) -> JSGroupInfo {
        let myGroupInfo = JSGroupInfo(name: "테스트 모임", mainImageUrl: "http://google.com", mainText: "테스트 모임 세계에 오신 것을 환영합니다.\n우리는 iOS 개발자 모임이며, 세계 최강 iOS Developer를 꿈꾸고 있습니다.", leaderPK: 1, leaderName: "이재성", location: .강남구, interestCategory: .스포츠, interest: .축구, address: "인천시 계양구 작전동", longitude: 100, latitude: 100)
        
        return myGroupInfo
    }
}
