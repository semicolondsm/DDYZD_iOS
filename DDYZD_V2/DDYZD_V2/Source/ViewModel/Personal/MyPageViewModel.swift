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
        let myInfo: PublishRelay<UserInfo>
        let belongClub: PublishRelay<[Club]>
        let modifyResult: PublishRelay<Bool>
    }
    
    func transform(_ input: input) -> output {
        let personalAPI = PersonalAPI()
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
                            myInfo.accept(data!)
                            if data!.clubs.count == 1 {
                                belongClub.accept(data!.clubs+[Club(club_id: -1, club_name: "", club_image: "")])
                            } else {
                                belongClub.accept(data!.clubs)
                            }
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
        
        return output(myInfo: myInfo, belongClub: belongClub, modifyResult: modifyResult)
    }
    
}
