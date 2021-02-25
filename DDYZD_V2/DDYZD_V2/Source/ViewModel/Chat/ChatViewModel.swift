//
//  ChatViewModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/19.
//

import Foundation

import RxCocoa
import RxSwift

class ChatViewModel: ViewModelProtocol {

    public var roomID: Int!
    
    private let disposeBag = DisposeBag()
    private var roomToken: SocketToken?
    
    struct input {
        let enterRoom: Driver<Void>
        let exitRoom: Driver<Void>
        let sendMessage: Driver<String>
    }
    
    struct output {
        let roomInfo: PublishRelay<RoomInfo>
        let breakdown: PublishRelay<[Chat]>
    }
    
    func transform(_ input: input) -> output {
        
        let chatAPI = ChatAPI()
        let roomInfo = PublishRelay<RoomInfo>()
        let breakdown = PublishRelay<[Chat]>()
        
        SocketIOManager.shared.establishConnection()
        
        input.enterRoom.asObservable().subscribe(onNext: {
            
            chatAPI.getRoomToken(roomID: self.roomID!).subscribe(onNext: { data, response in
                switch response {
                case .success:
                    Token.room_token = data?.room_token
                    SocketIOManager.shared.emit(.joinRoom)
                default:
                    break
                }
            })
            .disposed(by: self.disposeBag)
            
            chatAPI.getRoomInfo(roomID: self.roomID!).subscribe(onNext: { data, response in
                switch response {
                case .success:
                    roomInfo.accept(data!)
                default:
                    break
                }
            })
            .disposed(by: self.disposeBag)
            
            chatAPI.getBreakdown(roomID: self.roomID!).subscribe(onNext: { data, response in
                switch response {
                case .success:
                    breakdown.accept(data!)
                default:
                    break
                }
            })
            .disposed(by: self.disposeBag)
            
            SocketIOManager.shared.on(.receiveChat, callback: { data, _ in
                if let data = data as? [[String:Any]] {
                    for dataIndex in data {
                        let chat = Chat(title: dataIndex["title"] as? String ?? nil,
                                        msg: dataIndex["msg"] as! String,
                                        user_type: ChatType(rawValue: dataIndex["user_type"] as! String)!,
                                        created_at: dataIndex["date"] as! String)
                        breakdown.accept([chat])
                    }
                }
            })
        })
        .disposed(by: disposeBag)
        
        input.exitRoom.asObservable().subscribe(onNext: {
            SocketIOManager.shared.emit(.leaveRoom)
        })
        .disposed(by: disposeBag)
        
        input.sendMessage.asObservable().subscribe(onNext: { message in
            SocketIOManager.shared.emit(.sendChat(message: message))
        })
        .disposed(by: disposeBag)
            
        return output(roomInfo: roomInfo ,breakdown: breakdown)
    }
}
