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
        default:
            return nil
        }
    }
}
