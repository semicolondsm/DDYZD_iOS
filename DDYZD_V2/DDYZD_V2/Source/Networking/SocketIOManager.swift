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
    
    var manager = SocketManager(socketURL: URL(string: "http://api.semicolon.live")!,
                                config: [.log(true), .compress, .forceWebsockets(true), .reconnects(false), .extraHeaders(["Authorization": "Bearer \(Token.access_token)"]) ])
    var socket: SocketIOClient!
    
    init() {
        socket = self.manager.socket(forNamespace: "/chat")
        socket.on(clientEvent: .connect) {
            print($0)
            print($1)
        }
        socket.on(clientEvent: .error) {
            print($0)
            print($1)
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
