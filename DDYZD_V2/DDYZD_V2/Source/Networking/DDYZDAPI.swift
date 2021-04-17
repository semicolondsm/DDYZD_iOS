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
    case getGCN                                 // 학번 발급
    case refreshToken                           // 토큰 재발급
    case userInfo(_ gcn: String)                // 유저 정보
    case modifyGithubID                         // 깃허브 아이디 변경
    case modifyBio                              // 유저 소개 변경
    
    
    //feed
    case feedList(_ page: Int)                  // 모든 동아리의 피드리스트
    case clubFeedList(_ clubID: Int, _ page: Int)   // 특정 동아리의 피드리스트
    case flagIt(_ feedID: Int)                  // 피드 flag달기
    case uploadFeed(_ clubID: Int)              // 피드 올리기
    case modifyFeed(_ feedID: Int)              // 피드 수정
    case uploadFeedFile(_ feedID: Int)          // 피드 파일 업로드
    case deleteFeed(_ feedID: Int)              // 피드 삭제
    case pinFeed(_ feedID: Int)                 // 피드 고정
    case reportFeed                        // 피드 신고
    
    //club
    case clubList                           // 동아리 리스트 반환
    case clubDetailInfo(_ clubID: Int)      // 동아리 상세 정보
    case getRecruitment(_ clubID: Int)      // 모집 공고 정보 반환
    case getClubMember(_ clubID: Int)       // 동아리 멤버
    case cancelFollow(_ clubID: Int)        // 동아리 팔로우 취소
    case exitClub(_ clubID: Int)            // 소속 동아리 나가기
    case followClub(_ clubID: Int)          // 동아리 팔로우/ 팔로우 취소
    
    //Chat
    case chatList                           // 채팅 리스트
    case createChatRoom(_ clubID: Int)      // 채팅 룸 생성
    case deleteChatRoom(_ roomID: Int)      // 채팅 룸 삭제
    case getRoomToken(_ roomID: Int)        // 채팅방 토큰 발급
    case chatRoomInfo(_ roomID: Int)        // 채팅 룸 정보
    case chatBreakdown(_ roomID: Int)       // 채팅 내역
    
    
    func path() -> String {
        switch self {
        case .getToken(_):
            return "/users/token"
        case .postDeviceToken(_):
            return "/users/device_token"
        case .getGCN:
            return "/users/profile"
        case .refreshToken:
            return "/users/refresh"
        case .userInfo(let gcn):
            return "/users/\(gcn)"
        case .modifyGithubID:
            return "/users/profile/git"
        case .modifyBio:
            return "/users/profile/bio"
        case .feedList(let page):
            return "/feed/list?page=\(page)&"
        case .clubFeedList(let clubID, let page):
            return "/feed/\(clubID)/list?page=\(page)&"
        case .flagIt(let feedID):
            return "/feed/\(feedID)/flag"
        case .uploadFeed(let clubID):
            return "/feed/\(clubID)"
        case .modifyFeed(let feedID):
            return "/feed/\(feedID)"
        case .uploadFeedFile(let feedID):
            return "/feed/\(feedID)/medium"
        case .deleteFeed(let feedID):
            return "/feed/\(feedID)"
        case .pinFeed(let feedID):
            return "/feed/\(feedID)/pin"
        case .reportFeed:
            return "/report"
        case .clubList:
            return "/club/list"
        case .clubDetailInfo(let clubID):
            return "/club/\(clubID)/info"
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
        case .chatList:
            return "/chat/list"
        case .createChatRoom(let clubID):
            return "/chat/\(clubID)/room"
        case .deleteChatRoom(let roomID):
            return "/room/\(roomID)"
        case .getRoomToken(let roomID):
            return "/room/\(roomID)/token"
        case .chatRoomInfo(let roomID):
            return "/room/\(roomID)/info"
        case .chatBreakdown(let roomID):
            return "/chat/\(roomID)/breakdown"
        }
    }
    
    func header() -> HTTPHeaders? {
        switch self {
        case .clubList, .getClubMember(_), .reportFeed:
            return nil
        case .getToken(let DSMAuthToken) :
            return ["access-token": "Bearer \(DSMAuthToken)"]
        case .refreshToken :
            guard let refresh_token = Token.refresh_token else { return nil }
            return ["refresh-token": "Bearer \(refresh_token)"]
        case .postDeviceToken(let DeviceToekn):
            return ["device-token": "Bearer \(DeviceToekn)",
                    "Authorization": "Bearer \(Token.access_token)"]
        case .clubDetailInfo(_):
            if Token.access_token == "" { return nil }
            return ["Authorization": "Bearer \(Token.access_token)"]
        default:
            return ["Authorization": "Bearer \(Token.access_token)"]
        }
    }
}
