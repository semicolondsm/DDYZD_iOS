//
//  OtherUserPageViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/17.
//

import UIKit

import RxCocoa
import RxSwift
import Kingfisher

class OtherUserPageViewController: UIViewController {
    
    public var gcn: String!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gcnLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var githubLinkBtn: UIButton!
    @IBOutlet weak var noClubNotice: UILabel!
    @IBOutlet weak var belongClubCollectionView: UICollectionView!
    
    private let viewModel = OtherUserPageViewModel()
    private let disposeBag = DisposeBag()
    
    private let getUserInfo = PublishSubject<Void>()
    private let modifyGithubID = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        getInfo()
        setUI()
        setNavigationBar()
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getInfo()
    }

    func bind() {
        viewModel.gcn = gcn
        
        let input = OtherUserPageViewModel.input.init(getUserInfo: getUserInfo.asDriver(onErrorJustReturn: ()))
        let output = viewModel.transform(input)
        
        output.userInfo.subscribe(onNext: { userInfo in
            self.profileImage.kf.setImage(with: URL(string: userInfo.image_path ?? "" ))
            self.nameLabel.text = userInfo.name
            self.gcnLabel.text = userInfo.gcn
            self.emailLabel.text = userInfo.email
            self.bioLabel.text = userInfo.bio
            if let githubID = userInfo.github_url {
                self.githubLinkBtn.setTitle(" "+githubID, for: .normal)
                self.githubLinkBtn.isHidden = false
            } else {
                self.githubLinkBtn.isHidden = true
            }
            self.githubLinkBtn.rx.tap.subscribe(onNext: {
                if let githubID = userInfo.github_url {
                    self.openInSafari(url: "https://github.com/"+githubID)
                }
            })
            .disposed(by: self.disposeBag)
            
            if userInfo.clubs.count >= 1 {
                self.noClubNotice.isHidden = true
            }
            
        })
        .disposed(by: disposeBag)
        
        output.belongClub.bind(to: belongClubCollectionView.rx.items(cellIdentifier: "BelongClubCollectionViewCell", cellType: BelongClubCollectionViewCell.self)) { index, item, cell in
            cell.bind(item)
        }
        .disposed(by: disposeBag)
    }
    
    func getInfo() {
        getUserInfo.onNext(())
    }
    
}

//MARK:- UI
extension OtherUserPageViewController {
    
    func setUI(){
        profileImage.circleImage()
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}

//MARK:- CollectionView
extension OtherUserPageViewController: UICollectionViewDelegateFlowLayout {
    
    func setCollectionView(){
        belongClubCollectionView.delegate = self
        registerCell()
    }
    
    func registerCell() {
        let belongClubNib = UINib(nibName: "BelongClubCollectionViewCell", bundle: nil)
        belongClubCollectionView.register(belongClubNib, forCellWithReuseIdentifier: "BelongClubCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewCellWithd = belongClubCollectionView.frame.width / 5
        return CGSize(width: collectionViewCellWithd, height: 90)
    }
    
}
