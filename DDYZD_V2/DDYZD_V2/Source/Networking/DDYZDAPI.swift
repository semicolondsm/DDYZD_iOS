//
//  DDYZDAPI.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/17.
//

import Foundation

enum DDYZDAPI {
    
    //Auth
    case getToken
    case postDeviceToken
    case refreshToken
    case userInfo(_ gcn: String)
    case updateInfo
    
    func path() -> String {
        switch self {
        case .getToken:
            return "/users/token"
        case .postDeviceToken:
            return "/users/device_token"
        case .refreshToken:
            return "/users/refresh"
        case .userInfo(let gcn):
            return "/users/"+gcn
        case .updateInfo:
            return "/users/profile"
        }
    }
}
