//
//  JSDataCenter.swift
//  Chming_iOS
//
//  Created by leejaesung on 2017. 8. 1..
//  Copyright © 2017년 leejaesung. All rights reserved.
//

import Foundation

enum Gender:String {
    case man
    case woman
}

struct Member {
    let pkUser : Int
    let email : String
    var password : String
    var name : String
    var gender : Gender
    var birthYear : Int
    var birthMonth : Int
    var birthDay : Int
    var address : String
    var profileImageUrl : String
    
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
    }
    
    init(pkUser aPkUser:Int, email anEmail:String, password aPassword:String, name aName:String, gender aGender:Gender, birthYear aBirthYear:Int, birthMonth aBirthMonth:Int, birthDay aBirthDay:Int, address anAddress:String, profileImageUrl aProfileImageUrl:String) {
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
    }
    
//    init(name aName:String, gender aGender:String) {
//        self.name = aName
//        self.gender = aGender
//    }
    
}

struct Group {
    
}

struct Interest {
    
}

struct GroupJoinLike {
    
}

struct GroupBoard {
    
}


class DataCenter {
    
    static let sharedInstance = DataCenter()
    
    var memberList:[Member]?
    
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
    
}
