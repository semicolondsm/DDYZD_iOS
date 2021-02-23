//
//  SoketClient.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/01.
//

import Foundation

import RxCocoa
import SocketIO


class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    let manager = SocketManager(socketURL: URL(string: "https://api.semicolon.live")!,
                                config: [.log(true), .compress, .forceWebsockets(true), .reconnects(false), .extraHeaders(["Authorization": "Bearer \(Token.access_token)"]) ])
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        socket = manager.socket(forNamespace: "/chat")
        
        socket.on("response") {
            print($0)
            print($1)
        }
        
        socket.on(clientEvent: .connect) {
            print($0)
            print($1)
            print("connect")
        }
        socket.on(clientEvent: .error) {
            print($0)
            print($1)
            print("error")
        }
        
        socket.on(clientEvent: .disconnect) {
            print($0)
            print($1)
            print("disconnect")
        }
        
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
