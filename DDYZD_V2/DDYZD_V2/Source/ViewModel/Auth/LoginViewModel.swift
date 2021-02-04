//
//  LoginViewModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/20.
//

import Foundation

import DSMSDK
import FirebaseMessaging
import RxCocoa
import RxSwift

class LoginViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    struct input {
        let vc: UIViewController
        let loginWithDSMAuthBtnDriver: Driver<Void>
    }
    
    struct output {
        let result: Observable<String>
    }
    
    func transform(_ input: input) -> output {
        let api = AuthAPI()
        let result = PublishSubject<String>()
        
        input.loginWithDSMAuthBtnDriver.asObservable().subscribe(onNext: {
            DSMAUTH.loginWithDSMAuth(vc: input.vc){ (token, error) in
                if let error = error{
                    result.onError(error)
                } else {
                    api.signIn(token!.Access_Token).subscribe(onNext: { res in
                        switch res {
                        case .success:
                            Messaging.messaging().token{ token, err in
                                if err != nil { return } else {
                                    api.postDeviceToken(token!).asObservable().subscribe(onNext: { res in
                                        switch res {
                                        case .success:
                                            print("SUCCESS")
                                        default:
                                            print("ERROR")
                                        }
                                    })
                                    .disposed(by: self.disposeBag)
                                }
                            }
                            result.onCompleted()
                        default:
                            result.onNext("로그인 실패")
                        }
                    })
                    .disposed(by: self.disposeBag)
                }
            }
        })
        .disposed(by: disposeBag)
        
        return output(result: result)
    }
}
