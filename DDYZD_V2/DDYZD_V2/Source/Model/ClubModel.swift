//
//  ClubModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/21.
//

import Foundation

enum ClubListCategory {
    case all
    case web
    case app
    case embedded
    case ect
    case CA
    case Autonomy
    case Committee
    
    func title() -> String{
        switch  self {
        case .all:
            return "전체"
        case .web:
            return "웹"
        case .app:
            return "앱"
        case .embedded:
            return "임베디드"
        case .ect:
            return "기타"
        case .CA:
            return "창체"
        case .Autonomy:
            return "자율"
        case .Committee:
            return "위원회"
        }
    }
    
    func classificationTag(_ tag: String) -> Bool{
        switch self {
        case .all:
            return true
        case .web:
            if tag == "웹" {
                return true
            } else {
                return false
            }
        case .app:
            if tag == "앱" {
                return true
            } else {
                return false
            }
        case .embedded:
            if tag == "임베디드" {
                return true
            } else {
                return false
            }
        case .ect:
            if tag == "게임" || tag == "인공지능" || tag == "정보보안" {
                return true
            } else {
                return false
            }
        case .CA:
            if tag == "창체" {
                return true
            } else {
                return false
            }
        case .Autonomy:
            if tag == "자율" {
                return true
            } else {
                return false
            }
        case .Committee:
            if tag == "위원회" {
                return true
            } else {
                return false
            }
        }
    }
    
    static let allItems = [all,web,app,embedded,ect,CA,Autonomy,Committee]
}

struct ClubList: Codable {
    let clubid: Int
    let clubname: String
    let clubdescription: String?
    let clubimage: String
    let clubtag: [String]
    let clubrecruitment: Bool
}

struct ClubInfo: Codable {
    let clubid: Int
    let clubname: String
    let clubtag: [String]
    let clubimage: String
    let backimage: String
    let description: String?
    let recruitment: Bool
    let recruitment_close: String?
    let owner: Bool
    let follow: Bool
}

struct ClubMember: Codable {
    let user_id: Int?
    let user_name: String
    let gcn: String
    let profile_image: String?
    let git: String?
}

struct ChatRoom: Codable {
    let room_id: String
}
