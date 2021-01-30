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
    }
    
    struct output {
        let result: Observable<String>
        let chatList: PublishRelay<[ChatRoom]>
    }
    
    func transform(_ input: input) -> output {
        let api = ChatAPI()
        let result = PublishSubject<String>()
        let chatList = PublishRelay<[ChatRoom]>()
        
        api.getChatList().subscribe(onNext: { data, response in
            switch response {
            case .success:
                chatList.accept(data!)
                result.onCompleted()
            default:
                result.onNext("API 'getChatList' ERROR")
            }
        })
        .disposed(by: disposeBag)
        
        return output(result: result, chatList: chatList)
    }
}
