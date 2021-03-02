//
//  MainPageViewModel.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/31.
//

import Foundation

import RxCocoa
import RxSwift

class MainPageViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    private var feeds = [Feed]()
    private var lastLoadPage = 0
    
    struct input {
        let tokenRefresh: Driver<Void>
        let getFeed: Driver<LoadFeedAction>
        let flagIt: Driver<Int>
        let deleteFeed: Driver<Int>
    }
    
    struct output {
        let tokenRefreshResult: Observable<String>
        let feedList: PublishRelay<[Feed]>
        let flagItResult: PublishRelay<Bool>
    }
    
    func transform(_ input: input) -> output {
        let authAPI = AuthAPI()
        let feedAPI = FeedAPI()
        let tokenRefreshResult = PublishSubject<String>()
        let feedList = PublishRelay<[Feed]>()
        let flagItResult = PublishRelay<Bool>()
        
        input.tokenRefresh.asObservable().subscribe(onNext: {
            authAPI.refreshToken().subscribe(onNext: { res in
                switch res {
                case .success:
                    tokenRefreshResult.onCompleted()
                default:
                    tokenRefreshResult.onNext("토큰 재발급 실패")
                }
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        input.getFeed.asObservable().subscribe(onNext: { action in
            
            switch action {
            case .reload:
                self.feeds.removeAll()
                self.lastLoadPage = 0
                feedAPI.getFeedList(page: self.lastLoadPage).subscribe(onNext: { data, res in
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
                feedAPI.getFeedList(page: self.lastLoadPage).subscribe(onNext: { data, res in
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
                    flagItResult.accept(true)
                default:
                    flagItResult.accept(false)
                }
            })
            .disposed(by: self.disposeBag)
            
            feedList.accept(self.feeds)
        })
        .disposed(by: disposeBag)
        
        input.deleteFeed.asObservable().subscribe(onNext: { row in
            feedAPI.deleteFeed(feedID: self.feeds[row].feedId).subscribe(onNext: { res in
                switch res {
                case.success:
                    self.feeds.remove(at: row)
                    feedList.accept(self.feeds)
                default:
                    print("feed delete error")
                }
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        return output(tokenRefreshResult: tokenRefreshResult,
                      feedList: feedList,
                      flagItResult: flagItResult)
    }
    
}

enum LoadFeedAction {
    case reload
    case loadMore
}
