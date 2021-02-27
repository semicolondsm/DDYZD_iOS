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
    private var isRecruitmenting: Bool = false
    
    struct input {
        let enterRoom: Driver<Void>
        let exitRoom: Driver<Void>
        let sendMessage: Driver<String>
        let sendApply: Driver<String>
        let sendSchedule: Driver<(String, String)>
        let sendResult: Driver<Bool>
    }
    
    struct output {
        let roomInfo: PublishRelay<RoomInfo>
        let majorBeingRecruited: PublishRelay<[String]>
        let breakdown: PublishRelay<[Chat]>
        let chatProgress: PublishRelay<ChatType>
    }
    
    func transform(_ input: input) -> output {
        
        let chatAPI = ChatAPI()
        let roomInfo = PublishRelay<RoomInfo>()
        let isRecruitmenting = PublishRelay<Bool>()
        let majorBeingRecruited = PublishRelay<[String]>()
        let breakdown = PublishRelay<[Chat]>()
        let chatProgress = PublishRelay<ChatType>()
        
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
                    chatAPI.getRecruitmentInfo(clubID: Int(data!.id)!).subscribe(onNext: { data, response in
                        switch response {
                        case .success:
                            self.isRecruitmenting = true
                            majorBeingRecruited.accept(data!.major)
                        default:
                            isRecruitmenting.accept(false)
                        }
                        chatAPI.getBreakdown(roomID: self.roomID!).subscribe(onNext: { data, response in
                            switch response {
                            case .success:
                                if data!.isEmpty && self.isRecruitmenting{
                                    chatProgress.accept(.user)
                                } else {
                                    for index in 0..<data!.count {
                                        if data![index].user_type == .user || data![index].user_type == .Club{
                                            if index == data!.count-1 && self.isRecruitmenting{
                                                chatProgress.accept(.user)
                                            }
                                        } else {
                                            chatProgress.accept(data![index].user_type)
                                            break
                                        }
                                    }
                                }
                            default:
                                break
                            }
                        })
                        .disposed(by: self.disposeBag)
                    })
                    .disposed(by: self.disposeBag)
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
                                        created_at: dataIndex["date"] as? String ?? "",
                                        result: dataIndex["result"] as? Bool ?? false)
                        breakdown.accept([chat])
                        switch chat.user_type {
                        case .user, .Club:
                            break
                        default:
                            chatProgress.accept(chat.user_type)
                        }
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
        
        input.sendApply.asObservable().subscribe(onNext: { major in
            SocketIOManager.shared.emit(.sendApply(major: major))
        })
        .disposed(by: disposeBag)
        
        input.sendSchedule.asObservable().subscribe(onNext: { (date, location) in
            SocketIOManager.shared.emit(.sendSchdule(date: date, loaction: location))
        })
        .disposed(by: disposeBag)
        
        input.sendResult.asObservable().subscribe(onNext: { result in
            SocketIOManager.shared.emit(.sendResult(result: result))
        })
        .disposed(by: disposeBag)
            
        return output(roomInfo: roomInfo,
                      majorBeingRecruited: majorBeingRecruited,
                      breakdown: breakdown,
                      chatProgress: chatProgress)
    }
}
