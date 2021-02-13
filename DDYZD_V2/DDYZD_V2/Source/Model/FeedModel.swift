//
//  FeedModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/07.
//

import Foundation

struct FeedModel: Codable {
    let feedId: Int
    let clubName: String
    let profileImage: String
    let uploadAt: String
    let content: String
    let media: [String]
    var flags: Int
    let owner: Bool
    var flag: Bool
    let pin: Bool?
    let follow: Bool
}

