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
    let id: String
    let image: String
    let index: Int
    let isread: Bool
    let lastdate: String?
    let lastmessage: String?
    let name: String
    let roomid: String
    let status: ChatStatus
}

struct RoomInfo: Codable {
    let id: String
    let name: String
    let image: String
    let status: ChatStatus
}

struct RecruitmentInfo: Codable {
    let major: [String]
    let startat: String
    let closeat: String
}

struct Chat: Codable {
    let title: String?
    let msg: String
    let user_type: ChatType
    let created_at: String
    let result: Bool?
}

enum ChatType: String, Codable{
    case User = "U"
    case Club = "C"
    case Apply = "H1"
    case Schedule = "H2"
    case Result = "H3"
    case Answer = "H4"
}

enum UserType: String {
    case Volunteer = "U"
    case ClubHead = "C"
}

enum ChatStatus: String, Codable {
    case Common = "C"
    case Notificate = "N"
    case Applicant = "A"
    case Scheduled = "S"
    case Resulted = "R"
}
