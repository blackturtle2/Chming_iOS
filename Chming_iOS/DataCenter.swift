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
    }
    
    init(pkUser aPkUser:Int, email anEmail:String, password aPassword:String, name aName:String, gender aGender:Gender, birthYear aBirthYear:Int, birthMonth aBirthMonth:Int, birthDay aBirthDay:Int, address anAddress:String) {
        self.pkUser = aPkUser
        self.email = anEmail
        self.password = aPassword
        self.name = aName
        self.gender = aGender
        self.birthYear = aBirthYear
        self.birthMonth = aBirthMonth
        self.birthDay = aBirthDay
        self.address = anAddress
    }
    
//    init(name aName:String, gender aGender:String) {
//        self.name = aName
//        self.gender = aGender
//    }
    
}

struct LightMember {
    let pkUser : Int
    let email : String
    var password : String
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
    
    var memberList:[LightMember]?
    
    func signUpWith(member aMember:LightMember) -> Bool {
        
        guard let vMemberList = self.memberList else {
            print("/////guardlet")
            
            self.memberList = [aMember]
            print("/////memberList: ", self.memberList ?? "...")
            return true
        }
        
        self.memberList?.append(aMember)
        print("/////memberList: ", self.memberList ?? "...")
        
        return true
    }
    
    func signIn() -> Bool {
        
        
        return true
    }
    
}
