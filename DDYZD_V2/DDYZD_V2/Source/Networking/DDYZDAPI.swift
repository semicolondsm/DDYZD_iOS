//
//  DDYZDAPI.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/17.
//

import Foundation
import Alamofire

enum DDYZDAPI {
    
    //Auth
    case getToken(_ DSMAuthToken: String)
    case postDeviceToken
    case refreshToken
    case userInfo(_ gcn: String)
    case updateInfo
    
    //club
    case clubList
    case clubDetailInfo(_ clubID: Int)
    case getRecruitment(_ clubID: Int)
    case getClubMember(_ clubID: Int)
    case cancelFollow(_ clubID: Int)
    case exitClub(_ clubID: Int)
    case FollowClub(_ clubID: Int)
    
    
    func path() -> String {
        switch self {
        case .getToken(_):
            return "/users/token"
        case .postDeviceToken:
            return "/users/device_token"
        case .refreshToken:
            return "/users/refresh"
        case .userInfo(let gcn):
            return "/users/\(gcn)"
        case .updateInfo:
            return "/users/profile"
        case .clubList:
            return "/club/list"
        case .clubDetailInfo(let clubID):
            return "/club/\(clubID)"
        case .getRecruitment(let clubID):
            return "/club/\(clubID)/recruitment"
        case .getClubMember(let clubID):
            return "/club/\(clubID)/member"
        case .cancelFollow(let clubID):
            return "/club/\(clubID)/follow"
        case .exitClub(let clubID):
            return "/club/\(clubID)"
        case .FollowClub(let clubID):
            return "/club/\(clubID)/follow"
        }
    }
    
    func header() -> HTTPHeaders? {
        switch self {
        case .getToken(let DSMAuthToken) :
            return ["access_token": "Bearer \(DSMAuthToken)"]
        case .refreshToken :
            guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
                return nil
            }
            return ["refresh-token": "Bearer \(refreshToken)"]
        default:
            return nil
        }
    }
}
