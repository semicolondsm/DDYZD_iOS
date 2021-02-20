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
        let getClubInfo: Driver<Void>
        let getFeed: Driver<LoadFeedAction>
        let flagIt: Driver<Int>
        let deleteFeed: Driver<Int>
        let pinFeed: Driver<Int>
    }
    
    struct output {
        let clubInfo: PublishRelay<ClubInfoModel>
        let clubMembers: PublishRelay<[ClubMember]>
        let clubMemberNum: PublishRelay<Int>
        let feedList: PublishRelay<[FeedModel]>
        let flagItResult: PublishRelay<Bool>
        let pinFeedResult: PublishRelay<Bool>
    }
    
    func transform(_ input: input) -> output {
        
        let clubAPI = ClubAPI()
        let feedAPI = FeedAPI()
        let clubInfo = PublishRelay<ClubInfoModel>()
        let clubMembers = PublishRelay<[ClubMember]>()
        let clubMemberNum = PublishRelay<Int>()
        let feedList = PublishRelay<[FeedModel]>()
        let flagItResult = PublishRelay<Bool>()
        let pinFeedResult = PublishRelay<Bool>()
        
        input.getClubInfo.asObservable().subscribe(onNext: {
            clubAPI.getClubDetailInfo(clubID: self.clubID).subscribe(onNext: { data, res in
                switch res {
                case .success:
                    clubInfo.accept(data!)
                default:
                    print(res)
                }
            })
            .disposed(by: self.disposeBag)
            
            clubAPI.getClubMembers(clubID: self.clubID).asObservable().subscribe(onNext: { data, res in
                switch res {
                case .success:
                    clubMembers.accept(data!)
                    clubMemberNum.accept(data!.count)
                default:
                    print("get club member err")
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
        
        input.pinFeed.asObservable().subscribe(onNext: { row in
            feedAPI.pinFeed(feedID: self.feeds[row].feedId).subscribe(onNext: { res in
                switch res {
                case .success:
                    pinFeedResult.accept(true)
                default:
                    pinFeedResult.accept(false)
                }
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        return output(clubInfo: clubInfo,
                      clubMembers: clubMembers,
                      clubMemberNum: clubMemberNum,
                      feedList: feedList,
                      flagItResult: flagItResult,
                      pinFeedResult: pinFeedResult)
    }
}
