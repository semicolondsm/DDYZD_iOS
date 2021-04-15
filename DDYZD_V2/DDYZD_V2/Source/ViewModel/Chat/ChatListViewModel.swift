//
//  ChatListViewModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/30.
//

import Foundation

import RxCocoa
import RxSwift

class ChatListViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private var selectedChatSection = 0
    
    struct input {
        let loadSections: Driver<()>
        let loadList: Driver<Int>
        let selectIndexPath: Signal<IndexPath>
        let deleteChat: Driver<Int>
    }
    
    struct output {
        let result: PublishRelay<Bool>
        let sectionList: PublishRelay<[String]>
        let chatList: PublishRelay<[Room]>
        let roomID: Signal<Int>
    }
    
    func transform(_ input: input) -> output {
        let api = ChatAPI()
        let result = PublishRelay<Bool>()
        let sectionList = PublishRelay<[String]>()
        let chatList = PublishRelay<[Room]>()
        let roomID = PublishRelay<Int>()
        
        SocketIOManager.shared.establishConnection()
        
        input.loadSections.asObservable().subscribe(onNext: {
            api.getChatList().subscribe(onNext: { data, response in
                switch response {
                case .success:
                    sectionList.accept(data!.club_section)
                    result.accept(true)
                case .unauthorized:
                    result.accept(false)
                default:
                    result.accept(false)
                }
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        input.loadList.asObservable().subscribe(onNext: { sectionIndex in
            self.selectedChatSection = sectionIndex
            loadList()
        })
        .disposed(by: disposeBag)
        
        SocketIOManager.shared.on(.listChangeAlarm) { _, _ in
            loadList()
        }
        
        
        input.selectIndexPath.asObservable()
            .withLatestFrom(chatList){ indexPath, data in
                Int(data[indexPath.row].roomid)!
            }
            .subscribe{ roomID.accept($0) }
            .disposed(by: disposeBag)
        
        input.deleteChat.asObservable()
            .withLatestFrom(chatList){($0, $1)}
            .subscribe(onNext: { (indexPathRow, data) in
                var processedList = data
                processedList.remove(at: indexPathRow)
                chatList.accept(processedList)
                api.deleteRoom(roomID: Int(data[indexPathRow].roomid) ?? 0).subscribe({_ in
                }).disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        func loadList() {
            api.getChatList().subscribe(onNext: { data, response in
                switch response {
                case .success:
                    var roomsInSection = [Room]()
                    for room in data!.rooms {
                        if room.index == self.selectedChatSection {
                            roomsInSection.append(room)
                        }
                    }
                    chatList.accept(roomsInSection)
                    result.accept(true)
                case .unauthorized:
                    result.accept(false)
                default:
                    result.accept(false)
                }
            })
            .disposed(by: self.disposeBag)
        }
        
        return output(result: result,
                      sectionList: sectionList,
                      chatList: chatList,
                      roomID: roomID.asSignal())
    }
}
