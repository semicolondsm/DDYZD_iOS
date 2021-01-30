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
    }
    
    struct output {
        let result: Observable<String>
        let chatList: PublishRelay<[ChatRoom]>
    }
    
    func transform(_ input: input) -> output {
        let api = ChatAPI()
        let result = PublishSubject<String>()
        let chatList = PublishRelay<[ChatRoom]>()
        
        input.loadList.asObservable().subscribe(onNext: {
            api.getChatList().subscribe(onNext: { data, response in
                switch response {
                case .success:
                    chatList.accept(data!)
                    result.onCompleted()
                default:
                    result.onNext("API 'getChatList' ERROR")
                }
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        
        return output(result: result, chatList: chatList)
    }
}
