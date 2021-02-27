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
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var clubDescriptionLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var followGuideanceLabel: UILabel!
    @IBOutlet weak var chatGuideanceLabel: UILabel!
    @IBOutlet weak var clubMemberNumLabel: UILabel!
    @IBOutlet weak var clubMemberCollectionView: UICollectionView!
    
    private let viewModel = ClubDetailViewModel()
    private let disposeBag = DisposeBag()
    private let navigationBarTitile = UILabel()
    private var isFollowing = false
    private var isHead = false
    private var loadMore = false
    
    private let getClubInfo = PublishSubject<Void>()
    private let makeRoomID = PublishSubject<Void>()
    private let getFeed = PublishSubject<LoadFeedAction>()
    private let flagIt = PublishSubject<Int>()
    private let deleteFeed = PublishSubject<Int>()
    private let pinFeed = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setCollectionView()
        bind()
        getClubDetailInfo()
        setTableView()
        registerCell()
        reloadFeeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        SocketIOManager.shared.closeConnection()
    }
    
    func bind() {
        viewModel.clubID = clubID
        let input = ClubDetailViewModel.input(getClubInfo: getClubInfo.asDriver(onErrorJustReturn: ()),
                                              selectIndexPath: clubMemberCollectionView.rx.itemSelected.asDriver(),
                                              followClub: makeRoomID.asDriver(onErrorJustReturn: ()),
                                              chatWithClub: chatBtn.rx.tap.asDriver(),
                                              getFeed: getFeed.asDriver(onErrorJustReturn: .reload),
                                              flagIt: flagIt.asDriver(onErrorJustReturn: -1),
                                              deleteFeed: deleteFeed.asDriver(onErrorJustReturn: -1),
                                              pinFeed: pinFeed.asDriver(onErrorJustReturn: -1))
        let output = viewModel.transform(input)
        
        output.clubInfo.subscribe(onNext: { data in
            self.navigationBarTitile.text = data.clubname
            self.isHead = data.owner
            self.clubNameLabel.text = data.clubname
            self.fieldLabel.fieldLabel(clubTag: data.clubtag)
            self.clubDescriptionLabel.text = data.description
            self.clubBackImage.kf.setImage(with: URL(string: "https://api.semicolon.live/file/\(data.backimage)"))
            self.clubProfileImgae.kf.setImage(with: URL(string: "https://api.semicolon.live/file/\(data.clubimage)"))
            if data.follow {
                self.isFollowing = true
                self.followBtn.setBtnInClubDetail(type: .unfollow)
                self.followGuideanceLabel.isHidden = true
            } else {
                self.isFollowing = false
                self.followBtn.setBtnInClubDetail(type: .follow)
                self.followGuideanceLabel.isHidden = false
            }
            if data.recruitment {
                self.chatBtn.setBtnInClubDetail(type: .apply(deadline: data.recruitment_close!))
                self.chatGuideanceLabel.isHidden = false
            } else {
                self.chatBtn.setBtnInClubDetail(type: .chat)
                self.chatGuideanceLabel.isHidden = true
            }
        })
        .disposed(by: disposeBag)
        
        chatBtn.rx.tap.bind(onNext: {
            self.makeRoomID.onNext(())
        })
        .disposed(by: disposeBag)
        
        output.clubMemberNum.subscribe(onNext: { num in
            self.clubMemberNumLabel.text = "\(num)명"
        })
        .disposed(by: disposeBag)
        
        output.clubMembers.bind(to: clubMemberCollectionView.rx.items(cellIdentifier: "ClubMemberCollectionViewCell", cellType: ClubMemberCollectionViewCell.self)) { index, item, cell in
            cell.bind(index: index, item: item)
        }
        .disposed(by: disposeBag)
        
        followBtn.rx.tap.subscribe(onNext: {
            if self.isFollowing {
                self.isFollowing = false
                self.followBtn.setBtnInClubDetail(type: .follow)
                self.followGuideanceLabel.isHidden = false
            } else {
                self.isFollowing = true
                self.followBtn.setBtnInClubDetail(type: .unfollow)
                self.followGuideanceLabel.isHidden = true
            }
        })
        .disposed(by: disposeBag)
        
        output.followClubResult.subscribe(onNext: { res in
            if !res {
                self.moveLogin(didJustBrowsingBtnTaped: { self.getClubDetailInfo() }, didSuccessLogin: nil)
            }
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
                }).disposed(by: cell.disposeBag)
                
                return cell
            }
        }
        .disposed(by: disposeBag)
        
        output.selectedMemberGCN.subscribe(onNext: { GCN in
            self.goUserPageView(GCN)
        })
        .disposed(by: disposeBag)
        
        output.clubChatRoomID.subscribe(onNext: { roomID in
            if roomID == -1 {
                self.moveLogin(didJustBrowsingBtnTaped: nil, didSuccessLogin: { self.makeRoomID.onNext(()) })
            } else {
                self.goChatPage(roomID: roomID)
            }
        })
        .disposed(by: disposeBag)
        
        output.flagItResult.subscribe(onNext: { isSuccess in
            if !isSuccess {
                self.moveLogin(didJustBrowsingBtnTaped: nil, didSuccessLogin: nil)
            }
        })
        .disposed(by: disposeBag)
        
        output.pinFeedResult.subscribe(onNext: { isSuccess in
            if isSuccess {
                self.reloadFeeds()
            }
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
    
    func goUserPageView(_ gcn: String){
        self.navigationController?.navigationBar.shadowImage = nil
        let personalSB: UIStoryboard = UIStoryboard(name: "Personal", bundle: nil)
        let userPageVC = personalSB.instantiateViewController(identifier: "OtherUserPageViewController") as! OtherUserPageViewController
        userPageVC.gcn = gcn
        self.navigationController?.pushViewController(userPageVC, animated: true)
    }
    
    func goChatPage(roomID: Int){
        let chatSB: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        let chatVC = chatSB.instantiateViewController(identifier: "ChatViewController") as! ChatViewController
        chatVC.roomID = roomID
        chatVC.userType = .Volunteer
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}


// MARK:- UI
extension ClubDetailViewController {
    func setUI(){
        clubProfileImgae.circleImage()
        clubProfileImgae.layer.borderWidth = 3
        clubProfileImgae.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        followBtn.setBtnInClubDetail(type: .follow)
        chatBtn.setBtnInClubDetail(type: .chat)
        chatGuideanceLabel.isHidden = true
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.standardAppearance.shadowColor = .gray
        navigationController?.navigationBar.standardAppearance.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4811326265, green: 0.1003668979, blue: 0.812384963, alpha: 1)
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 22))

        navigationBarTitile.font = navigationBarTitile.font.withSize(20)
        navigationBarTitile.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(navigationBarTitile)

        let leftButtonWidth: CGFloat = 35 // left padding
        let rightButtonWidth: CGFloat = 75 // right padding
        let width = view.frame.width - leftButtonWidth - rightButtonWidth
        let offset = (rightButtonWidth - leftButtonWidth) / 2
        
        NSLayoutConstraint.activate([
            navigationBarTitile.topAnchor.constraint(equalTo: container.topAnchor),
            navigationBarTitile.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            navigationBarTitile.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: -offset),
            navigationBarTitile.widthAnchor.constraint(equalToConstant: width)
        ])

        self.navigationItem.titleView = container
    }
    
}

// MARK:- collection view
extension ClubDetailViewController: UICollectionViewDelegateFlowLayout {
    func setCollectionView(){
        clubMemberCollectionView.delegate = self
        registerCollectionViewCell()
    }
    
    func registerCollectionViewCell() {
        let clubMemberNib = UINib(nibName: "ClubMemberCollectionViewCell", bundle: nil)
        clubMemberCollectionView.register(clubMemberNib, forCellWithReuseIdentifier: "ClubMemberCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 80)
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
