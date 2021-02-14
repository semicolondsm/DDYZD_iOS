//
//  ClubDetailViewModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/04.
//

import Foundation

import RxCocoa
import RxSwift

class ClubDetailViewModel: ViewModelProtocol {
    
    public var clubID = 0
    
    private let disposeBag = DisposeBag()
    
    private var feeds = [FeedModel]()
    private var lastLoadPage = 0
    
    struct input {
        let getFeed: Driver<LoadFeedAction>
        let flagIt: Driver<Int>
    }
    
    struct output {
        let feedList: PublishRelay<[FeedModel]>
        let flagItResult: Observable<String>
    }
    
    func transform(_ input: input) -> output {
        
        let feedAPI = FeedAPI()
        let feedList = PublishRelay<[FeedModel]>()
        let flagItResult = PublishSubject<String>()
        
        input.getFeed.asObservable().subscribe(onNext: { action in
            switch action {
            case .reload:
                self.feeds.removeAll()
                self.lastLoadPage = 0
                feedAPI.getClubFeedList(clubID: self.clubID, page: self.lastLoadPage).subscribe(onNext: { data, res in
                    switch res {
                    case .success:
                        self.feeds.append(contentsOf: data!)
                        feedList.accept(self.feeds)
                    default:
                        print(res)
                    }
                })
                .disposed(by: self.disposeBag)
            case .loadMore:
                self.lastLoadPage += 1
                feedAPI.getClubFeedList(clubID: self.clubID, page: self.lastLoadPage).subscribe(onNext: { data, res in
                    switch res {
                    case .success:
                        self.feeds.append(contentsOf: data!)
                        feedList.accept(self.feeds)
                    default:
                        self.lastLoadPage -= 1
                        print(res)
                    }
                })
                .disposed(by: self.disposeBag)
            }
        })
        .disposed(by: disposeBag)
        
        input.flagIt.asObservable().subscribe(onNext: { row in
            
            if self.feeds[row].flag {
                self.feeds[row].flags -= 1
            } else {
                self.feeds[row].flags += 1
            }
            self.feeds[row].flag = !self.feeds[row].flag
            
            feedAPI.flagIt(feedID: self.feeds[row].feedId).subscribe(onNext: { res in
                switch res {
                case .success:
                    flagItResult.onCompleted()
                case .unauthorized:
                    flagItResult.onNext("unauthorized")
                default:
                    flagItResult.onNext("API 'flagIt' ERROR")
                }
            })
            .disposed(by: self.disposeBag)
            
            feedList.accept(self.feeds)
        })
        .disposed(by: disposeBag)
        
        return output(feedList: feedList, flagItResult: flagItResult)
    }
}
