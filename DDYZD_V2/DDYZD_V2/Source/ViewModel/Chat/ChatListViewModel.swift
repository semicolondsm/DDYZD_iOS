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
    
    let disposeBag = DisposeBag()
    
    struct input {
        let loadList: Signal<Void>
        let selectIndexPath: Signal<IndexPath>
    }
    
    struct output {
        let result: Observable<String>
        let chatList: PublishRelay<[ChatRoom]>
        let roomID: Signal<Int>
    }
    
    func transform(_ input: input) -> output {
        let api = ChatAPI()
        let result = PublishSubject<String>()
        let chatList = PublishRelay<[ChatRoom]>()
        let roomID = PublishRelay<Int>()
        
        input.loadList.asObservable().subscribe(onNext: {
            api.getChatList().subscribe(onNext: { data, response in
                switch response {
                case .success:
                    chatList.accept(data!)
                    result.onCompleted()
                case .unauthorized:
                    result.onNext("Incorrect Token")
                default:
                    result.onNext("API 'getChatList' ERROR")
                }
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        input.selectIndexPath.asObservable()
            .withLatestFrom(chatList){ indexPath, data in
                data[indexPath.row].roomid
            }
            .subscribe{ roomID.accept($0) }
            .disposed(by: disposeBag)
        
        return output(result: result,
                      chatList: chatList,
                      roomID: roomID.asSignal())
    }
}
