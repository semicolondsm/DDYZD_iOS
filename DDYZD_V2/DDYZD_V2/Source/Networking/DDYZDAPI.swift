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
    case getToken(_ DSMAuthToken: String)       // 토큰 발급
    case postDeviceToken(_ DeviceToken: String) // 디바이스 토큰 입력
    case refreshToken                           // 토큰 재발급
    case userInfo(_ gcn: String)                // 유저 정보
    case updateInfo                             // 프로필 수정
    
    //feed
    case flagIt(_ feedID: Int)              // 피드 flag달기
    case uploadFeed(_ clubID: Int)          // 피드 올리기
    case updateFeed(_ feedID: Int)          // 피드 수정
    case uploadFeedFile(_ feedID: Int)      // 피드 파일 업로드
    
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
    
    //Chat
    case chatList                           // 채팅 리스트
    case createChatRoom(_ clubID: Int)      // 채팅 룸 생성
    case chatBreakdown(_ roomID: Int)       // 채팅 내역
    
    
    func path() -> String {
        switch self {
        case .getToken(_):
            return "/users/token"
        case .postDeviceToken(_):
            return "/users/device_token"
        case .refreshToken:
            return "/users/refresh"
        case .userInfo(let gcn):
            return "/users/\(gcn)"
        case .updateInfo:
            return "/users/profile"
        case .flagIt(let feedID):
            return "/feed/\(feedID)/flag"
        case .uploadFeed(let clubID):
            return "feed/\(clubID)"
        case .updateFeed(let feedID):
            return "feed/\(feedID)"
        case .uploadFeedFile(let feedID):
            return "feed/\(feedID)/medium"
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
        case .chatList:
            return "/chat/list"
        case .createChatRoom(let clubID):
            return "chat/\(clubID)/room"
        case .chatBreakdown(let roomID):
            return "/chat/\(roomID)/breakdown"
        }
    }
    
    func header() -> HTTPHeaders? {
        switch self {
        case .clubList, .clubDetailInfo(_), .getRecruitment(_), .getClubMember(_):
            return nil
        case .getToken(let DSMAuthToken) :
            return ["access_token": "Bearer \(DSMAuthToken)"]
        case .refreshToken :
            guard let refresh_token = Token.refresh_token else { return nil }
            return ["refresh-token": "Bearer \(refresh_token)"]
        case .postDeviceToken(let DeviceToekn):
            return ["device-token": "Bearer \(DeviceToekn)"]
        case .updateProfileImage(_), .updateHongboImage(_), .updateBannerImage(_), .uploadFeedFile(_):
            return ["Authorization": "Bearer \(Token.access_token)",
                    "Content-Type": "multipart/form-data"]
        default:
            return ["Authorization": "Bearer \(Token.access_token)"]
        }
    }
}
