//
//  Token.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/20.
//

import Foundation

struct TokenModel: Codable {
    let accessToken: String
    let refreshToken: String
}

struct Token {
    static var accessToken: String = ""
}
