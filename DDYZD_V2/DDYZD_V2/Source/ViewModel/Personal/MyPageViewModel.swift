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
        let modifyGitID: Driver<String>
    }
    
    struct output {
        let getInfoResult: PublishRelay<Bool>
        let myInfo: PublishRelay<UserInfo>
        let belongClub: PublishRelay<[Club]>
        let modifyResult: PublishRelay<Bool>
    }
    
    func transform(_ input: input) -> output {
        let personalAPI = PersonalAPI()
        let getInfoResult = PublishRelay<Bool>()
        let myInfo = PublishRelay<UserInfo>()
        let belongClub = PublishRelay<[Club]>()
        let modifyResult = PublishRelay<Bool>()
        
        input.getMyInfo.asObservable().subscribe(onNext: {
            personalAPI.getGCN().subscribe(onNext: { gcn, res in
                switch res {
                case .success:
                    personalAPI.getUserInfo(gcn: gcn!.gcn).asObservable().subscribe(onNext: { data, res in
                        switch res {
                        case .success:
                            getInfoResult.accept(true)
                            myInfo.accept(data!)
                            belongClub.accept(data!.clubs)
                        default:
                            getInfoResult.accept(false)
                            print("get user info: \(res)")
                        }
                    })
                    .disposed(by: self.disposeBag)
                default:
                    getInfoResult.accept(false)
                    print("get gcn: \(res)")
                }
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        input.modifyGitID.asObservable().subscribe(onNext: { githubID in
            personalAPI.modifyGithubID(githubID: githubID).subscribe(onNext: { res in
                switch res {
                case .success:
                    modifyResult.accept(true)
                default:
                    modifyResult.accept(false)
                }
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        return output(getInfoResult: getInfoResult, myInfo: myInfo, belongClub: belongClub, modifyResult: modifyResult)
    }
    
}
