//
//  SoketClient.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/01.
//

import Foundation

import RxCocoa
import SocketIO


class SocketIOManager {
    
    var manager = SocketManager(socketURL: URL(string: "ws://api.semicolon.live")!, config: [.log(false), .compress])
    var socket: SocketIOClient!
    
    init(_ room: String) {
        socket = self.manager.socket(forNamespace: "/"+room)
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
