//
//  MyPageViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/17.
//

import UIKit

import RxCocoa
import RxSwift
import Kingfisher

class MyPageViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gcnLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var githubLinkBtn: UIButton!
    @IBOutlet weak var noClubNotice: UILabel!
    @IBOutlet weak var belongClubCollectionView: UICollectionView!
    @IBAction func menuBtn(_ sender: Any) { openMenu() }
    
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    
    private let getMyInfo = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        getInfo()
        setUI()
        setNavigationBar()
        setCollectionView()
    }

    func bind() {
        let input = MyPageViewModel.input.init(getMyInfo: getMyInfo.asDriver(onErrorJustReturn: ()))
        let output = viewModel.transform(input)
        
        
        
        output.myInfo.subscribe(onNext: { userInfo in
            self.profileImage.kf.setImage(with: URL(string: userInfo.image_path ?? "" ))
            self.nameLabel.text = userInfo.name
            self.gcnLabel.text = userInfo.gcn
            self.emailLabel.text = userInfo.email
            self.bioLabel.text = userInfo.bio
            self.githubLinkBtn.setTitle(" "+(userInfo.github_url ?? "깃허브 아이디를 등록해주세요!"), for: .normal)
            self.githubLinkBtn.rx.tap.subscribe(onNext: {
                if let githubID = userInfo.github_url {
                    self.openInSafari(url: "https://github.com/"+githubID)
                } else {
                    // 깃허브 아이디 등록 alret
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
        getMyInfo.onNext(())
    }
    
    func openMenu(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let changeGithubID = UIAlertAction(title: "Github 계정 변경", style: .default) { _ in
            let alert = UIAlertController(title: "Github 계정 변경", message: nil, preferredStyle: .alert)
            alert.addTextField(){ textField in
                textField.placeholder = "Github id"
            }
            let ok = UIAlertAction(title: "OK", style: .default) { _ in
                self.showToast(message: alert.textFields![0].text!)
            }
            let cancel = UIAlertAction(title: "cancel", style: .cancel)
            alert.addAction(cancel)
            alert.addAction(ok)
            alert.view.tintColor = .black
            self.present(alert, animated: true, completion: nil)
        }
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            //로그아웃
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(changeGithubID)
        alert.addAction(logout)
        alert.addAction(cancle)
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK:- UI
extension MyPageViewController {
    
    func setUI(){
        profileImage.circleImage()
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 44.0))

        let label = UILabel(frame: CGRect(x: -40, y: 0.0, width: 150.0, height: 44.0))
        label.text = "마이 페이지"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = NSTextAlignment.right
        customView.addSubview(label)

        let leftButton = UIBarButtonItem(customView: customView)
        navigationItem.leftBarButtonItem = leftButton
    }
    
}

//MARK:- CollectionView
extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    
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
