//
//  DDYZDSocket.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/25.
//

import Foundation

enum DDYZDSocket {
    
    // emit
    case joinRoom                   // 채팅방 입장
    case leaveRoom                  // 채팅방 나가기
    case sendChat(message: String)  // 채팅 보내기
    case sendApply(major: String)   // 지원하기
    case sendSchdule(date: String, loaction: String)
    
    // on
    case listChangeAlarm             // 채팅리스트 변동 알림 받기
    case receiveChat                 // 채팅받기
    
    func event() -> String {
        switch  self {
        case .joinRoom:
            return "join_room"
        case .leaveRoom:
            return "leave_room"
        case .sendChat:
            return "send_chat"
        case .sendApply:
            return "helper_apply"
        case .sendSchdule:
            return "helper_schedule"
        case .listChangeAlarm:
            return "alarm"
        case .receiveChat:
            return "recv_chat"
        }
    }
    
    func items() -> [String:Any]? {
        switch self {
        case .joinRoom, .leaveRoom:
            return ["room_token": Token.room_token ?? ""]
        case .sendChat(let msg):
            return ["room_token": Token.room_token ?? "", "msg": msg]
        case .sendApply(let major):
            return ["room_token": Token.room_token ?? "", "major": major]
        case .sendSchdule(let date, let location):
            return ["room_token": Token.room_token ?? "", "date": date, "location": location]
        default:
            return nil
        }
    }
}
