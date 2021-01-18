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
    
    //only head authority
    case makeRecruitment(_ clubID: Int)     // 동아리 모집 공고 생성
    case updateProfileImage(_ clubID: Int)  // 동아리 프로필 이미지 등록
    case updateHongboImage(_ clubID: Int)   // 동아리 홍보물 등록
    case updateBannerImage(_ clubID: Int)   // 동아리 베너 등록
    case updateClubInfo(_ clibID: Int)      // 동아리 정보 수정
    case assignmentHead(_ clubID: Int)      // 동아리 헤드 양도
    
    
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
        case .updateProfileImage(let clubID):
            return "/club/\(clubID)/profile"
        case .updateHongboImage(let clubID):
            return "/club/\(clubID)/hongbo"
        case .updateBannerImage(let clubID):
            return "/club/\(clubID)/banner"
        case .updateClubInfo(let clubID):
            return "/club/\(clubID)"
        case .assignmentHead(let clubID):
            return "/club/\(clubID)/head"
        }
    }
    
    func header() -> HTTPHeaders? {
        switch self {
        case .clubList, .clubDetailInfo(_), .getRecruitment(_), .getClubMember(_):
            return nil
        case .getToken(let DSMAuthToken) :
            return ["access_token": "Bearer \(DSMAuthToken)"]
        case .refreshToken :
            guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
                return nil
            }
            return ["refresh-token": "Bearer \(refreshToken)"]
        case .updateProfileImage(_), .updateHongboImage(_), .updateBannerImage(_):
            return ["Authorization": "Bearer 여기 토큰",
                    "Content-Type": "multipart/form-data"]
        default:
            return ["Authorization": "Bearer 여기 토큰"]
        }
    }
}
