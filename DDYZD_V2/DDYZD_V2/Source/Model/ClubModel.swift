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
    
    static let allItems = [all,web,app,embedded,ect,CA]
}
