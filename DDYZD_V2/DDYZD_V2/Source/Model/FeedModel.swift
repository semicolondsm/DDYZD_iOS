//
//  FeedModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/07.
//

import Foundation

struct FeedListModel: Codable {
    let feedId: Int
    let clubName: String
    let profileImage: String
    let isFollow: Bool
    let uploadAt: String
    let content: String
    let media: [medium]
    let isFlag: Bool
    let flags: Int
}

struct Medium: Codable {
    let medium: String
}
