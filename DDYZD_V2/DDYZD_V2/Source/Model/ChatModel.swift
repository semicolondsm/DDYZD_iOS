//
//  ChatModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/24.
//

import Foundation

struct ChatRoom: Codable {
    let roomid: Int
    let clubid: Int
    let clubname: String
    let clubimage: String
    let userid: Int
    let username: String
    let userimage: String
    let lastdate: String?
    let lastmessage: String?
}
