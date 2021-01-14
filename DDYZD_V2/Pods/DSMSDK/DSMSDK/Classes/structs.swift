//
//  structs.swift
//  DSMSDK
//
//  Created by 김수완 on 2021/01/01.
//

import Foundation

public struct personInfo: Codable{
    public let name : String
    public let StudentID : String
    public let email : String
}

public struct Token{
    public let Access_Token : String
    public let Refresh_Token : String
}
