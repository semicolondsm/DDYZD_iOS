//
//  ClubListViewModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/21.
//

import Foundation

import RxCocoa
import RxSwift

class ClubListTableViewModel: ViewModelProtocol {
    
    let disposeBag = DisposeBag()
    
    struct input {
        let clubTag: ClubListCategory
        let selectIndexPath: Signal<IndexPath>
    }
    
    struct output {
        let result: Observable<String>
        let clubList: PublishRelay<[ClubListModel]>
        let clubID: Signal<Int>
    }
    
    func transform(_ input: input) -> output {
        let api = ClubAPI()
        let result = PublishSubject<String>()
        let clubList = PublishRelay<[ClubListModel]>()
        let clubID = PublishSubject<Int>()
        
        api.getClubList().subscribe(onNext:{ data, response in
            switch response {
            case .success:
                var returnClubList = [ClubListModel]()
                
                for club in data! {
                    for tag in club.clubtag {
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
        
        input.selectIndexPath.asObservable()
            .withLatestFrom(clubList){ indexPath, data in
                data[indexPath.row].clubid
            }
            .subscribe{ clubID.onNext($0)}
            .disposed(by: disposeBag)
        
        return output(result: result, clubList: clubList, clubID: clubID.asSignal(onErrorJustReturn: 0))
    }
    
}
