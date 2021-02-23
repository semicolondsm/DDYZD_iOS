//
//  ChatModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/24.
//

import Foundation

struct ChatList: Codable {
    let club_section: [String]
    let rooms: [Room]
}

struct Room: Codable {
    let roomid: String
    let id: String
    let name: String
    let image: String
    let lastdate: String?
    let lastmessage: String?
    let index: Int
}

struct Chat: Codable {
    let title: String?
    let msg: String
    let user_type: ChatType
    let created_at: String
}

enum ChatType: String, Codable{
    case user = "U"
    case Club = "C"
    case Apply = "H1"
    case Schedule = "H2"
    case Result = "H3"
}

enum UserType: String {
    case Volunteer = "U"
    case ClubHead = "C"
}
