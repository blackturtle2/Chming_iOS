//
//  JSDataCenter.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 8..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import Foundation


// MARK: 모임 정보 구조체
struct JSGroupInfo {
    let name: String
    
    let mainImageUrl: String?
    let mainText: String?
    
    let leaderPK: Int
    let leaderName: String
    var memberList:[String]?
    
    let location: eLocalList
    let interestCategory: eInterestCategory
    let interest: eInterest
    
    let address: String
    let longitude: Double
    let latitude: Double
}

// MARK: 모임 게시판 구조체
// 배열로 감싸고 리턴 필요.
struct JSGroupBoard {
    let boardPK: Int
    let createdDate: Date
    
    let isNotice: Bool
    let title: String
    let content: String
    let imageURL: String?
    
    let writerPK: Int
    let writerName: String
    let writerProfileImageURL: String?
}

// MARK: 모임 게시판의 댓글 구조체
// 배열로 감싸고 리턴 필요.
struct JSGroupBoardComment {
    let commnetPK: Int
    let createdDate: Date
    
    let content: String
    
    let writerPK: Int
    let writer: String
}


/*******************************************/
// MARK: -  JSDataCenter                   //
/*******************************************/

class JSDataCenter {
    
    static let shared = JSDataCenter()
    
    var selectedGroupPK:Int?
    
    init() {
        self.selectedGroupPK = nil
    }
    
    // MARK: GroupInfo 메소드.
    // groupPK를 넣으면, JSGroupInfo 형태로 리턴하는 메소드입니다.
    // 일단, 임시 데이터이고, 추후 여기에서 통신이 이루어질 예정입니다.
    // GroupInfoViewController에서 이 값들을 받아서 UI에 뿌릴 예정입니다.
    func findGroupInfo(ofGroupPK: Int) -> JSGroupInfo {
        var resultGroupInfo = JSGroupInfo(
            name: "테스트 모임",
            mainImageUrl: "http://cfile27.uf.tistory.com/image/265AAB42544A1F1C136ED6",
            mainText: "테스트 모임 세계에 오신 것을 환영합니다.\n우리는 iOS 개발자 모임이며, 세계 최강 iOS Developer를 꿈꾸고 있습니다.",
            leaderPK: 1,
            leaderName: "이재성",
            memberList: nil,
            location: .강남구,
            interestCategory: .스포츠,
            interest: .축구,
            address: "인천시 계양구 작전동",
            longitude: 100,
            latitude: 100
        )
        
        resultGroupInfo.memberList = ["김세화", "이창호", "황기수", "서현종", "김은영", "윤새결"]
        
        return resultGroupInfo
    }
    
    // MARK: 공지사항 메소드
    // 모임 공지사항 리스트를 리턴하는 메소드.
    // groupPK를 넣으면, 배열로 공지사항 리스트를 리턴합니다.
    // 일단, 임시 데이터이고, 추후 여기에서 통신이 이루어질 예정입니다.
    // GroupInfoViewController에서 이 값들을 받아서 UI에 뿌릴 예정입니다.
    func findNoticeList(ofGroupPK: Int) -> [JSGroupBoard] {
        let myGroupNoticeList1 = JSGroupBoard(boardPK: 0, createdDate: Date(), isNotice: true, title: "첫번째 공지사항입니다.", content: "공지사항 테스트입니다. 잘 보이나요? 두줄을 넘어가기 위해 장문으로 작성해봅니다.", imageURL: nil, writerPK: 1, writerName: "이재성", writerProfileImageURL: nil)
        let myGroupNoticeList2 = JSGroupBoard(boardPK: 1, createdDate: Date(), isNotice: true, title: "두번째 공지사항입니다.", content: "두번째 공지사항 테스트입니다. 잘 보이나요? 두줄을 넘어가기 위해 장문으로 작성해봅니다.", imageURL: nil, writerPK: 1, writerName: "이재성", writerProfileImageURL: nil)
        let resultArray = [myGroupNoticeList1, myGroupNoticeList2]
        
        return resultArray
    }
    
    // MARK: 모임 게시판 데이터 메소드
    func findGroupBoardList(ofGroupPK: Int) -> [JSGroupBoard] {
        let myGroupList1 = JSGroupBoard(boardPK: 2, createdDate: Date(), isNotice: false, title: "여기 오프라인 모임은 얼마나 자주 갖는 편인가요?", content: "안녕하세요? 저 오늘 가입했는데, 주말 정도에만 오프라인 모임 갈 수 있을 것 같아요.\n얼마나 자주 하는지 답변 부탁드립니다.", imageURL: nil, writerPK: 2, writerName: "황기수", writerProfileImageURL: "http://cfile229.uf.daum.net/image/27448F4B55FAAA9809A431")
        let myGroupList2 = JSGroupBoard(boardPK: 3, createdDate: Date(), isNotice: false, title: "저 오늘 가입했어요.", content: "안녕하세요? 오늘 가입했습니다.\n이제 iOS 개발 시작한지 3개월 정도 되었는데, 실력이 높은 개발자분들 많이 만나서 조언 듣고 싶습니다.\n반갑습니다. :D", imageURL: "http://pm1.narvii.com/6388/1d2f5d9672a126ca93bbda8c87dba1835e9a013a_hq.jpg", writerPK: 3, writerName: "이창호", writerProfileImageURL: "http://cfile27.uf.tistory.com/image/266F773758FF10A81B5B49")
        
        let resultArray = [myGroupList1, myGroupList2]
        
        return resultArray
    }
}
