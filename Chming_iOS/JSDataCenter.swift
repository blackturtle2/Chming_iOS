//
//  JSDataCenter.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 8..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import Foundation
import SwiftyJSON


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
    let createdDate: String
    
    let isNotice: Bool
    let title: String
    let content: String
    var imageURL: String?
    
    let writerPK: Int
    let writerName: String
    let writerProfileImageURL: String?
    
    let postLikeCount: Int
    let commentCount: Int
    
}

// MARK: 모임 게시판의 댓글 구조체
// 배열로 감싸고 리턴 필요.
struct JSGroupBoardComment {
    let commentPK: Int
    let createdDate: Date
    
    let content: String
    
    let writerPK: Int
    let writerName: String
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
    // json을 넣으면, JSGroupInfo 형태로 리턴하는 메소드입니다.
    // GroupInfoViewController에서 이 값들을 받아서 UI에 뿌릴 예정입니다.
    func findGroupInfo(ofResponseJSON json: JSON) -> JSGroupInfo {
        
        var resultGroupInfo = JSGroupInfo(
            name: json["name"].stringValue,
            mainImageUrl: json["image"].stringValue,
            mainText: json["description"].stringValue,
            leaderPK: json["author"]["pk"].intValue,
            leaderName: json["author"]["username"].stringValue,
            memberList: nil,
            location: .강남구,
            interestCategory: .스포츠,
            interest: .축구,
            address: json["address"].stringValue,
            longitude: 100,
            latitude: 100
        )
        
        resultGroupInfo.memberList = json["members"].arrayValue.map({ (jsonArray) -> String in
            return jsonArray["username"].stringValue
        })
        
        return resultGroupInfo
    }
    
    // MARK: 공지사항 메소드
    // 모임 공지사항 리스트를 리턴하는 메소드.
    // json을 넣으면, 배열로 공지사항 리스트를 리턴합니다.
    // GroupInfoViewController에서 이 값들을 받아서 UI에 뿌릴 예정입니다.
    func findNoticeList(ofResponseJSON json: JSON) -> [JSGroupBoard] {
        
        // json["notice"] 값이 parameter로 옵니다.
        let jsonMappingResult: [JSGroupBoard] = json.arrayValue.map { (jsonjson) -> JSGroupBoard in
            var resultInResult = JSGroupBoard(boardPK: jsonjson["pk"].intValue,
                                              createdDate: jsonjson["created_date"].stringValue,
                                              isNotice: jsonjson["post_type"].boolValue,
                                              title: jsonjson["title"].stringValue,
                                              content: jsonjson["content"].stringValue,
                                              imageURL: nil,
                                              writerPK: jsonjson["author"]["pk"].intValue,
                                              writerName: jsonjson["author"]["username"].stringValue,
                                              writerProfileImageURL: jsonjson["author"]["profile_img"].stringValue,
                                              postLikeCount: jsonjson["post_like_count"].intValue,
                                              commentCount: jsonjson["comments_count"].intValue)
            if jsonjson["post_img"].stringValue != "" {
                resultInResult.imageURL = jsonjson["post_img"].stringValue
            }
            
            return resultInResult
        }
        
        // 매핑한 결과에서 공지사항이 맞는 것들만 필터링합니다.
        // 모임 정보 뷰에서는 의미가 없고, 모임 게시판 뷰에서 활용됩니다.
        let result = jsonMappingResult.filter { (isIncluded) -> Bool in
            return isIncluded.isNotice == true
        }
        
        return result
    }
    
    // MARK: 모임 게시판 리스트 데이터 메소드
    func findGroupBoardList(ofResponseJSON json: JSON) -> [JSGroupBoard] {
        
        let jsonMappingResult = json.arrayValue.map { (jsonjson) -> JSGroupBoard in
            var resultInResult = JSGroupBoard(boardPK: jsonjson["pk"].intValue,
                                              createdDate: jsonjson["created_date"].stringValue,
                                              isNotice: jsonjson["post_type"].boolValue,
                                              title: jsonjson["title"].stringValue,
                                              content: jsonjson["content"].stringValue,
                                              imageURL: nil,
                                              writerPK: jsonjson["author"]["pk"].intValue,
                                              writerName: jsonjson["author"]["username"].stringValue,
                                              writerProfileImageURL: jsonjson["author"]["profile_img"].stringValue,
                                              postLikeCount: jsonjson["post_like_count"].intValue,
                                              commentCount: jsonjson["comments_count"].intValue)
            if jsonjson["post_img"].stringValue != "" {
                resultInResult.imageURL = jsonjson["post_img"].stringValue
            }
            
            return resultInResult
        }
        
        // 매핑한 결과에서 공지사항이 아닌 것들을 filterring합니다.
        let commonListResult = jsonMappingResult.filter { (isIncluded) -> Bool in
            return isIncluded.isNotice == false
        }
        
        // 피터링한 결과를 PK 순서에 맞게 sorting합니다.
        let result = commonListResult.sorted { (param1, param2) -> Bool in
            return param1.boardPK < param2.boardPK
        }
        
        return result
    }
    
    // MARK: 모임 게시판 디테일 데이터 메소드
    func findBoardData(ofBoardPK: Int) -> JSGroupBoard {
        
        switch ofBoardPK {
        case 0:
            let myGroupNoticeList1 = JSGroupBoard(boardPK: 0, createdDate: "date", isNotice: true, title: "첫번째 공지사항입니다.", content: "공지사항 테스트입니다. 잘 보이나요? 두줄을 넘어가기 위해 장문으로 작성해봅니다.", imageURL: nil, writerPK: 1, writerName: "이재성", writerProfileImageURL: nil, postLikeCount: 1, commentCount: 1)
            return myGroupNoticeList1
            
        default:
            let tempGroupList = JSGroupBoard(boardPK: 2, createdDate: "date", isNotice: false, title: "여기 오프라인 모임은 얼마나 자주 갖는 편인가요?", content: "안녕하세요? 저 오늘 가입했는데, 주말 정도에만 오프라인 모임 갈 수 있을 것 같아요.\n얼마나 자주 하는지 답변 부탁드립니다.", imageURL: nil, writerPK: 2, writerName: "황기수", writerProfileImageURL: "http://cfile229.uf.daum.net/image/27448F4B55FAAA9809A431", postLikeCount: 1, commentCount: 1)
            
            return tempGroupList
        }
    }
    
    // MARK: 사용자 프로필 이미지 URL 가져오는 메소드
    func findUserProfileImageURL(ofUserPK: Int) -> URL? {
        let resultString = "http://cfile229.uf.daum.net/image/27448F4B55FAAA9809A431"
        
        return URL(string: resultString)
    }
    
    // MARK: 댓글 리스트 가져오는 메소드
    func findCommentList(ofBoardPK: Int) -> [JSGroupBoardComment] {
        let resultCommentList1 = JSGroupBoardComment(commentPK: 0, createdDate: Date(), content: "댓글 테스트입니다.", writerPK: 0, writerName: "이재성")
        let resultCommentList2 = JSGroupBoardComment(commentPK: 0, createdDate: Date(), content: "댓글 테스트입니다.", writerPK: 0, writerName: "이재성")
        
        return [resultCommentList1, resultCommentList2]
    }
    
}
