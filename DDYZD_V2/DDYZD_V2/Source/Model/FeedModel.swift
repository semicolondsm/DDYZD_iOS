//
//  FeedModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/07.
//

import Foundation

struct Feed: Codable {
    let feedId: Int
    let clubName: String
    let clubId: Int?
    let profileImage: String
    let uploadAt: String
    let content: String
    let media: [String]
    var flags: Int
    let owner: Bool
    var flag: Bool
    var pin: Bool?
    let follow: Bool
}

