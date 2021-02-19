//
//  MyPageViewModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/17.
//

import Foundation

import RxCocoa
import RxSwift


class MyPageViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    struct input {
        let getMyInfo: Driver<Void>
    }
    
    struct output {
        let myInfo: PublishRelay<UserInfo>
        let belongClub: PublishRelay<[Club]>
    }
    
    func transform(_ input: input) -> output {
        let personalAPI = PersonalAPI()
        let myInfo = PublishRelay<UserInfo>()
        let belongClub = PublishRelay<[Club]>()
        
        input.getMyInfo.asObservable().subscribe(onNext: {
            personalAPI.getGCN().subscribe(onNext: { gcn, res in
                switch res {
                case .success:
                    personalAPI.getUserInfo(gcn: gcn!.gcn).asObservable().subscribe(onNext: { data, res in
                        switch res {
                        case .success:
                            myInfo.accept(data!)
                            belongClub.accept(data!.clubs)
                        default:
                            print("get user info: \(res)")
                        }
                    })
                    .disposed(by: self.disposeBag)
                default:
                    print("get gcn: \(res)")
                }
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        return output(myInfo: myInfo, belongClub: belongClub)
    }
    
}
