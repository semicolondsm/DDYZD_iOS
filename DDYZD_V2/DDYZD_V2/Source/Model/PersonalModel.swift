//
//  PersonalModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/17.
//

import Foundation

struct GCN: Codable {
    let gcn: String
}

struct UserInfo: Codable {
    let name: String
    let gcn: String
    let git: String
    let email: String
    let image: String
    let bio: String
    let clubs: [Club]
}

struct Club: Codable {
    let club_name: String
    let club_id: String
    let club_image: String
}
