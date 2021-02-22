//
//  OtherUserPageViewModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/17.
//

import Foundation

import RxCocoa
import RxSwift


class OtherUserPageViewModel: ViewModelProtocol {
    
    public var gcn: String!
    
    private let disposeBag = DisposeBag()
    
    struct input {
        let getUserInfo: Driver<Void>
    }
    
    struct output {
        let userInfo: PublishRelay<UserInfo>
        let belongClub: PublishRelay<[Club]>
    }
    
    func transform(_ input: input) -> output {
        let personalAPI = PersonalAPI()
        let userInfo = PublishRelay<UserInfo>()
        let belongClub = PublishRelay<[Club]>()
        
        input.getUserInfo.asObservable().subscribe(onNext: {
            personalAPI.getUserInfo(gcn: self.gcn!).asObservable().subscribe(onNext: { data, res in
                switch res {
                case .success:
                    userInfo.accept(data!)
                    belongClub.accept(data!.clubs)
                default:
                    print("get user info: \(res)")
                }
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        return output(userInfo: userInfo, belongClub: belongClub)
    }
}
