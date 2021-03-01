//
//  PersonalModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/17.
//

import Foundation

struct GCN: Codable {
    var gcn: String
}

struct UserInfo: Codable {
    let id: Int
    let name: String
    let gcn: String
    let image_path: String?
    let github_url: String?
    let email: String
    let bio: String?
    let clubs: [Club]
}

struct Club: Codable {
    let club_id: Int
    let club_name: String
    let club_image: String
}
