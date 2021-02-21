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
            if tag == "교과목" || tag == "전공과목" || tag == "스포츠" || tag == "예술 창의 교양" || tag == "교내활동" || tag == "기타" {
                return true
            } else {
                return false
            }
        }
    }
    
    static let allItems = [all,web,app,embedded,ect,CA]
}

struct ClubListModel: Codable {
    let clubid: Int
    let clubname: String
    let clubdescription: String
    let clubimage: String
    let clubtag: [String]
}

struct ClubInfoModel: Codable {
    let clubid: Int
    let clubname: String
    let clubtag: [String]
    let clubimage: String
    let backimage: String
    let description: String
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
