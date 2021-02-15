//
//  ClubDetailViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/04.
//

import UIKit

import RxCocoa
import RxSwift
import Kingfisher

class ClubDetailViewController: UIViewController {

    public var clubID = 0
    
    @IBOutlet weak var feedTable: UITableView!
    @IBOutlet weak var clubBackImage: UIImageView!
    @IBOutlet weak var clubProfileImgae: UIImageView!
    @IBOutlet weak var clubNameLabel: UILabel!
    
    private let viewModel = ClubDetailViewModel()
    private let disposeBag = DisposeBag()
    private var isHead = false
    private var loadMore = false
    
    private let getClubInfo = PublishSubject<Void>()
    private let getFeed = PublishSubject<LoadFeedAction>()
    private let flagIt = PublishSubject<Int>()
    private let deleteFeed = PublishSubject<Int>()
    private let pinFeed = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
        getClubDetailInfo()
        setTableView()
        registerCell()
        reloadFeeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
    }
    
    func bind() {
        viewModel.clubID = clubID
        let input = ClubDetailViewModel.input(getClubInfo: getClubInfo.asDriver(onErrorJustReturn: ()),
                                              getFeed: getFeed.asDriver(onErrorJustReturn: .reload),
                                              flagIt: flagIt.asDriver(onErrorJustReturn: -1),
                                              deleteFeed: deleteFeed.asDriver(onErrorJustReturn: -1),
                                              pinFeed: pinFeed.asDriver(onErrorJustReturn: -1))
        let output = viewModel.transform(input)
        
        output.clubInfo.subscribe(onNext: { data in
            self.isHead = data.owner
            self.clubNameLabel.text = data.clubname
            self.clubBackImage.kf.setImage(with: URL(string: "https://api.semicolon.live/file/\(data.backimage)"))
            self.clubProfileImgae.kf.setImage(with: URL(string: "https://api.semicolon.live/file/\(data.clubimage)"))
        })
        .disposed(by: disposeBag)
        
        output.feedList.bind(to: feedTable.rx.items) { _, row, item -> UITableViewCell in
            self.loadMore = false
            if item.media.isEmpty {
                let cell = self.feedTable.dequeueReusableCell(withIdentifier: "Feed") as! FeedTableViewCell
                
                cell.bind(item: item)
                cell.MenuBtn.rx.tap.subscribe(onNext: {
                    self.menuActionSheet(item: item, isHead: self.isHead, pinCloser: {
                        self.pinFeed.onNext(row)
                    }, deleteCloser: {
                        self.deleteFeed.onNext(row)
                    })
                })
                .disposed(by: cell.disposeBag)
                cell.flagBtn.rx.tap.subscribe(onNext: {
                    self.flagIt.onNext(row)
                    output.flagItResult.subscribe(onNext: { err in
                        self.moveLogin(didJustBrowsingBtnTaped: nil, didSuccessLogin: nil)
                    })
                    .disposed(by: cell.disposeBag)
                }).disposed(by: cell.disposeBag)
                
                return cell
            } else {
                let cell = self.feedTable.dequeueReusableCell(withIdentifier: "FeedWithMedia") as! FeedWithMediaTableViewCell
                
                cell.bind(item: item)
                cell.MenuBtn.rx.tap.subscribe(onNext: {
                    self.menuActionSheet(item: item, isHead: self.isHead, pinCloser: {
                        self.pinFeed.onNext(row)
                    }, deleteCloser: {
                        self.deleteFeed.onNext(row)
                    })
                })
                .disposed(by: cell.disposeBag)
                cell.flagBtn.rx.tap.subscribe(onNext: {
                    self.flagIt.onNext(row)
                    output.flagItResult.subscribe(onNext: { err in
                        self.moveLogin(didJustBrowsingBtnTaped: nil, didSuccessLogin: nil)
                    })
                    .disposed(by: cell.disposeBag)
                }).disposed(by: cell.disposeBag)
                
                return cell
            }
        }
        .disposed(by: disposeBag)
        
        output.pinFeedResult.subscribe(onCompleted: {
            self.reloadFeeds()
        })
        .disposed(by: disposeBag)
    }
    
    func getClubDetailInfo(){
        getClubInfo.onNext(())
    }
    
    func reloadFeeds(){
        getFeed.onNext(.reload)
    }
    
    func loadMoreFeeds(){
        loadMore = true
        getFeed.onNext(.loadMore)
    }
    

}


// MARK:- UI
extension ClubDetailViewController {
    func setUI(){
        clubProfileImgae.circleImage()
        clubProfileImgae.layer.borderWidth = 3
        clubProfileImgae.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.standardAppearance.shadowColor = .gray
        navigationController?.navigationBar.standardAppearance.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4811326265, green: 0.1003668979, blue: 0.812384963, alpha: 1)
    }
}


// MARK:- table view
extension ClubDetailViewController: UITableViewDelegate {
    
    func setTableView(){
        feedTable.separatorStyle = .none
        feedTable.allowsSelection = false
        feedTable.delegate = self
        initRefresh()
    }
    
    func registerCell() {
        let feedNib = UINib(nibName: "Feed", bundle: nil)
        feedTable.register(feedNib, forCellReuseIdentifier: "Feed")
        let feedWithMediadNib = UINib(nibName: "FeedWithMedia", bundle: nil)
        feedTable.register(feedWithMediadNib, forCellReuseIdentifier: "FeedWithMedia")
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? FeedTableViewCell {
            cell.disposeBag = DisposeBag()
            cell.flagBtn.isSelected = false
            cell.cellSuperView.layer.borderWidth = 0
        } else if let cell = cell as? FeedWithMediaTableViewCell {
            cell.disposeBag = DisposeBag()
            cell.flagBtn.isSelected = false
            cell.cellSuperView.layer.borderWidth = 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
                
        if offsetY > contentHeight - scrollView.frame.height{
            if !loadMore {
                loadMoreFeeds()
            }
        }
    }
    
    func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshFeed(refresh:)), for: .valueChanged)
        feedTable.refreshControl = refresh
    }
    
    @objc func refreshFeed(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        getClubDetailInfo()
        reloadFeeds()
    }
}
