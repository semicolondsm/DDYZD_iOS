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
    }
    
    func transform(_ input: input) -> output {
        return output()
    }
    
}
