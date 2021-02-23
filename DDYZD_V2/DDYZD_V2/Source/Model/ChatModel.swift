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
    let roomid: Int
    let id: Int
    let name: String
    let image: String
    let lastdate: String?
    let lastmessage: String?
    let index: Int
}
