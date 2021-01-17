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
    case getToken(_ DSMAuthToken: String)   // 토큰 발급
    case postDeviceToken                    // 디바이스 토큰 입력
    case refreshToken                       // 토큰 재발급
    case userInfo(_ gcn: String)            // 유저 정보
    case updateInfo                         // 프로필 수정
    
    //club
    case clubList                           // 동아리 리스트 반환
    case clubDetailInfo(_ clubID: Int)      // 동아리 상세 정보
    case getRecruitment(_ clubID: Int)      // 모집 공고 정보 반환
    case getClubMember(_ clubID: Int)       // 동아리 멤버
    case cancelFollow(_ clubID: Int)        // 동아리 팔로우 취소
    case exitClub(_ clubID: Int)            // 소속 동아리 나가기
    case followClub(_ clubID: Int)          // 동아리 팔로우
    
    //head authority
    case makeRecruitment(_ clubID: Int)     // 동아리 모집 공고 생성
    
    
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
        case .followClub(let clubID):
            return "/club/\(clubID)/follow"
        case .makeRecruitment(let clubID):
            return "/club/\(clubID)/recruitment"
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
