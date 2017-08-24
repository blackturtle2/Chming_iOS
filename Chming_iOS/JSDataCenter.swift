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
    let createdDate: String
    
    let content: String
    
    let writerPK: Int
    let writerName: String
    var writerProfileImgURL: String?
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
    func findBoardData(ofResponseJSON json: JSON) -> JSGroupBoard {
        var result = JSGroupBoard(boardPK: json["pk"].intValue,
                            createdDate: json["created_date"].stringValue,
                            isNotice: json["post_type"].boolValue,
                            title: json["title"].stringValue,
                            content: json["content"].stringValue,
                            imageURL: nil,
                            writerPK: json["author"]["pk"].intValue,
                            writerName: json["author"]["username"].stringValue,
                            writerProfileImageURL: json["author"]["profile_img"].stringValue,
                            postLikeCount: json["post_like_count"].intValue,
                            commentCount: json["comments_count"].intValue)
        if json["post_img"].stringValue != "" {
            result.imageURL = json["post_img"].stringValue
        }
        
        return result
    }
    
    // MARK: 사용자 프로필 이미지 URL 가져오는 메소드
    func findUserProfileImageURL(ofUserPK: Int) -> URL? {
        let resultString = "http://cfile229.uf.daum.net/image/27448F4B55FAAA9809A431"
        
        return URL(string: resultString)
    }
    
    // MARK: 댓글 리스트 가져오는 메소드
    func findCommentList(ofResponseJSON json: JSON) -> [JSGroupBoardComment] {
        let commentResult: [JSGroupBoardComment] = json.arrayValue.map { (jsonjson) -> JSGroupBoardComment in
            var resultInResult = JSGroupBoardComment(commentPK: jsonjson["pk"].intValue,
                                       createdDate: jsonjson["created_date"].stringValue,
                                       content: jsonjson["content"].stringValue,
                                       writerPK: jsonjson["author"]["pk"].intValue,
                                       writerName: jsonjson["author"]["username"].stringValue,
                                       writerProfileImgURL: nil)
            if jsonjson["author"]["profile_img"].stringValue != "" {
                resultInResult.writerProfileImgURL = jsonjson["author"]["profile_img"].stringValue
            }
            return resultInResult
        }
        
        // 피터링한 결과를 PK 순서에 맞게 sorting합니다.
        let result = commentResult.sorted { (param1, param2) -> Bool in
            return param1.commentPK < param2.commentPK
        }
        
        return result
    }
    
}
