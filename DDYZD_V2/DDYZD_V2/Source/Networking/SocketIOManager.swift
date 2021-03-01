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
    static let shared = SocketIOManager()
    let manager = SocketManager(socketURL: URL(string: "https://api.semicolon.live")!,
                                config: [.log(true), .compress, .forceWebsockets(true), .reconnects(false), .extraHeaders(["Authorization": "Bearer \(Token.access_token)"]) ])
    var socket: SocketIOClient!
    
    init() {
        socket = manager.socket(forNamespace: "/chat")
        
        socket.on("error", callback: {
            print("====== ERROR: Socket ======")
            print($0)
            print($1)
            print("...........................")
        })
        
        socket.on(clientEvent: .connect) {
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
    
    func on(_ api: DDYZDSocket, callback: @escaping (([Any], SocketAckEmitter)->Void)) {
        socket.on(api.event(), callback: callback)
    }
    
    func emit(_ api: DDYZDSocket) {
        socket.emit(api.event(), api.items()!)
    }
}
