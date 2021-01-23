//
//  ClubListViewModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/21.
//

import Foundation

import RxCocoa
import RxSwift

class ClubListViewModel: ViewModelProtocol {
    
    let disposeBag = DisposeBag()
    
    struct input {
        let clubTag: ClubListCategory
    }
    
    struct output {
        let result: Observable<String>
        let clubList: PublishRelay<[ClubListModel]>
    }
    
    func transform(_ input: input) -> output {
        let api = ClubAPI()
        let result = PublishSubject<String>()
        let clubList = PublishRelay<[ClubListModel]>()
        
        api.getClubList().subscribe(onNext:{ data, response in
            switch response {
            case .success:
                var returnClubList = [ClubListModel]()
                
                for club in data! {
                    for tag in club.clubTag {
                        if input.clubTag.classificationTag(tag) {
                            returnClubList.append(club)
                            break
                        }
                    }
                }

                clubList.accept(returnClubList)
                result.onCompleted()
                
            default:
                result.onNext("API 'getClubList' ERROR")
            }
        })
        .disposed(by: disposeBag)
        
        return output(result: result, clubList: clubList)
    }
    
}
