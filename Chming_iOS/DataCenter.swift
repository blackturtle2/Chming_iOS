//
//  JSDataCenter.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import Foundation

let userDefaultsPk:String = "userPK"
let userDefaultsToken:String = "userToken"
let rootDomain:String = "http://chming.jeongmyeonghyeon.com"

enum Gender:String {
    case man
    case woman
}

struct Member {
    let pkUser: Int
    let email: String
    var password: String
    var name: String
    var gender: Gender
    var birthYear: Int
    var birthMonth: Int
    var birthDay: Int
    var address: String
    var profileImageUrl: String
    var interest: eInterest
    
    
    init(with data:[String:Any]) {
        self.pkUser = data["pkUser"] as! Int
        self.email = data["email"] as! String
        self.password = data["password"] as! String
        self.name = data["friend_name"] as! String
        self.gender = Gender(rawValue: data["gender"] as! Gender.RawValue)!
        self.birthYear = data["birthYear"] as! Int
        self.birthMonth = data["birthMonth"] as! Int
        self.birthDay = data["birthDay"] as! Int
        self.address = data["address"] as! String
        self.profileImageUrl = data["profileImageUrl"] as! String
        self.interest = eInterest(rawValue: data["interest"] as! eInterest.RawValue)!
    }
    
    init(pkUser aPkUser:Int, email anEmail:String, password aPassword:String, name aName:String, gender aGender:Gender, birthYear aBirthYear:Int, birthMonth aBirthMonth:Int, birthDay aBirthDay:Int, address anAddress:String, profileImageUrl aProfileImageUrl:String, interest anInterest:eInterest) {
        self.pkUser = aPkUser
        self.email = anEmail
        self.password = aPassword
        self.name = aName
        self.gender = aGender
        self.birthYear = aBirthYear
        self.birthMonth = aBirthMonth
        self.birthDay = aBirthDay
        self.address = anAddress
        self.profileImageUrl = aProfileImageUrl
        self.interest = anInterest
    }
    
//    init(name aName:String, gender aGender:String) {
//        self.name = aName
//        self.gender = aGender
//    }
    
}

struct GroupOne {
    let groupPK:Int
    let latitude:Double
    let longitude:Double
    // latitude: 위도, longitude: 경도
}

struct GroupDetail {
    let pk: Int
    let location: eLocalList
    let interestCategory: eInterestCategory
    let interest: eInterest
    let name: String
    let mainImageUrl: String?
    let mainText: String?
    let address: String
    let longitude: Double
    let latitude: Double
    let leaderPK: Int
    let leaderName: String
    let memberList: [String] = []
    // "모임 공지 사항 리스트" 프로퍼티 필요.
}

enum eLocalList:String {
    // 지역 리스트 - https://ko.wikipedia.org/wiki/서울특별시의_행정_구역
    case 종로구
    case 중구
    case 용산구
    case 성동구
    case 광진구
    case 동대문구
    case 중랑구
    case 성북구
    case 강북구
    case 도봉구
    case 노원구
    case 은평구
    case 서대문구
    case 마포구
    case 양천구
    case 강서구
    case 구로구
    case 금천구
    case 영등포구
    case 동작구
    case 관악구
    case 서초구
    case 강남구
    case 송파구
    case 강동구
}

enum eInterestCategory:String {
    case 감상
    case 스포츠
}

enum eInterest:String {
    case 축구
    case 야구
    case 농구
    case 영화
    case 음악
    case 연극
}

/* 관심사 리스트 - http://biki45.blogspot.kr/2015/02/blog-post_1.html
 감상 = [ 영화, 음악, 연극, 뮤지컬, 콘서트, 미술관, 박물관, 독서 ]
 DIY = [ 한지공예, 목공예, 도자기공예, 가죽공예, 가구만들기, 천연비누화장품, 십자수 ]
 만들기 = [ 비즈공예, 리본공예, 와이어공예, 자수, 풍선아트, 종이접기, 선물포장 ]
 요리 = [ 한식, 중식, 일식, 양식 ]
 스포츠 = [ 축구, 야구, 농구, 족구, 탁구, 당구, 골프 ]
 운동 = [ 자전거, 등산, 마라톤, 수영, 암벽타기, 스키, 보드, 댄스, 헬스 ]
 애견 = [ 개, 고양이, 고슴도치, 물고기, 토끼, 파충류 ]
 공부 = [ 독서, 영어, 중국어, 일본어, 프랑스어, 한문 ]
 */

struct GroupJoinLike {
    
}

struct GroupBoard {
    
}


class DataCenter {
    
    static let sharedInstance = DataCenter()
    
    
    // MARK: //// Member 관련
    var memberList:[Member]?
    
    init() {
        
        // 임시 회원가입 데이터
        self.memberList = [Member(pkUser: 1, email: "test@gmail.com", password: "123456", name: "mingming", gender: .man, birthYear: 2017, birthMonth: 08, birthDay: 20, address: "취밍시 취밍구 취밍동", profileImageUrl: "http://test.com", interest: .축구)]
        
    }
    
    func signUpWith(member aMember:Member) -> Bool {
        
        // 회원가입 예제 코드 시작 - //
        // 회원 목록 배열에 회원을 추가하는 소스입니다. 아래 부분을 지우고, FB Auth 회원가입 로직을 태웁니다.
        // return true는 회원가입의 성공 여부를 체크합니다. 성공하지 못할 경우, false를 리턴하고, 뷰 컨트롤러에서 Alert 등의 에러 처리를 합니다.
        if memberList == nil {
            memberList = [aMember]
            print("/////memberList: ", self.memberList ?? "...")
            return true
        }
        
        self.memberList?.append(aMember)
        print("/////memberList: ", self.memberList ?? "...")
        
        return true
        // 회원가입 예제 코드 끝 - //
        
    }
    
    func signInWith(memberEmail anEmail:String, memberPassword aPassword:String) -> Bool {
        
        // 로그인 예제 코드 시작 - //
        // return true일 때, 로그인이 성공된 것입니다.
        // return false이면, 로그인 실패이고, 가입된 이메일이 아니거나 비밀번호가 일치하지 않았을 때입니다. 사용자에게 어떤 이유로 로그인 실패인지는 알려주지 않습니다. Alert 메시지는 "일치하는 회원 정보가 없습니다. 다시 입력해주세요."라고 띄웁니다.
        // 사용자에게 이유를 알려주고 싶은 경우, Bool을 return하지 말고, Int 형태의 코드로 리턴해서 뷰컨트롤러가 판단하도록 합니다. ( 혹은 enum 구조로 만드는 것이 최고의 구조 )
        guard let vMemberList = self.memberList else {
            print("memberList 데이터가 없습니다.")
            return false
        }
        
        for i in vMemberList {
            if i.email == anEmail {
                if i.password == aPassword {
                    UserDefaults.standard.set(i.pkUser, forKey: userDefaultsPk) //User의 PK를 UserDefaults에 저장해서 다양한 뷰에서 사용합니다.
                    print("로그인 성공-!")
                    return true
                }
                print("비밀번호가 일치하지 않습니다.")
                return false
            }
        }
        
        print("일치하는 이메일 주소가 없습니다.")
        return false
        // 로그인 예제 코드 끝 - //
        
    }
    
    
    // MARK: ///// 모임 관련
    
    // 지역 데이터인, "구"와 관심사 데이터를 받아서 모임 리스트를 리턴하는 메소드입니다.
    func findGroupList(locationGOO:eLocalList, interest:eInterest) -> [GroupOne] {
        // 지역 > 좌표 > { 위도, 경도 }
        // 지역 > 모임 > 관심사 > { 그룹 리스트 }
        // location > interest > groupList
        
        return [GroupOne(groupPK: 1, latitude: 100, longitude: 100)]
    }
    
    
}
