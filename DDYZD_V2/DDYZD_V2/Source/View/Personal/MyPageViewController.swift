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
    private let modifyGithubID = PublishSubject<String>()
    private let modifyBio = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setNavigationBar()
        setCollectionView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getInfo()
    }

    func bind() {
        let input = MyPageViewModel.input.init(getMyInfo: getMyInfo.asDriver(onErrorJustReturn: ()),
                                               modifyGitID: modifyGithubID.asDriver(onErrorJustReturn: ""),
                                               modifyBio: modifyBio.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input)
        
        output.getInfoResult.subscribe(onNext: { isSuccess in
            if !isSuccess {
                self.moveLogin(didJustBrowsingBtnTaped: {
                    self.tabBarController?.selectedIndex = 0
                }, didSuccessLogin: {
                    self.getInfo()
                })
            }
        })
        .disposed(by: disposeBag)
        
        output.myInfo.subscribe(onNext: { userInfo in
            self.profileImage.kf.setImage(with: kfImageURL(url: userInfo.image_path ?? "", type: .all))
            self.nameLabel.text = userInfo.name
            self.gcnLabel.text = userInfo.gcn
            self.emailLabel.text = userInfo.email
            self.bioLabel.text = userInfo.bio
            self.githubLinkBtn.setTitle(" "+(userInfo.github_url ?? "깃허브 아이디를 등록해주세요!"), for: .normal)
            self.githubLinkBtn.rx.tap.subscribe(onNext: {
                if let githubID = userInfo.github_url {
                    self.openInSafari(url: "https://github.com/"+githubID)
                } else {
                    self.changeGithubIDAlert()
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
        
        output.modifyResult.subscribe(onNext: { res in
            if res {
                self.getInfo()
            }
        })
        .disposed(by: disposeBag)
    }
    
    func getInfo() {
        getMyInfo.onNext(())
    }
    
    func openMenu(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyBio = UIAlertAction(title: "소개 수정", style: .default) { _ in
            self.processModifyBio()
        }
        let changeGithubID = UIAlertAction(title: "Github 계정 변경", style: .default) { _ in
            self.changeGithubIDAlert()
        }
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            Token.access_token = ""
            Token.refresh_token = ""
            self.tabBarController?.selectedIndex = 0
            self.moveLogin(didJustBrowsingBtnTaped: nil, didSuccessLogin: nil)
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionSheet.addAction(modifyBio)
        actionSheet.addAction(changeGithubID)
        actionSheet.addAction(logout)
        actionSheet.addAction(cancle)
        actionSheet.view.tintColor = .black
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func changeGithubIDAlert(){
        let alert = UIAlertController(title: "Github 계정 변경", message: nil, preferredStyle: .alert)
        let label = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height:18))
        label.textAlignment = .center
        label.textColor = .red
        label.font = label.font.withSize(12)
        alert.view.addSubview(label)
        label.isHidden = true
        alert.addTextField(){ textField in
            textField.placeholder = "Github id"
        }
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            if alert.textFields![0].text! == "" {
                label.text = ""
                label.text = "Github 아이디를 입력해 주세요!"
                label.isHidden = false
                self.present(alert, animated: true, completion: nil)
            } else {
                self.modifyGithubID.onNext(alert.textFields![0].text!)
            }
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
    }
    
    func processModifyBio() {
        let personalSB: UIStoryboard = UIStoryboard(name: "Personal", bundle: nil)
        let modifyBioVC = personalSB.instantiateViewController(identifier: "ModifyBioViewController") as! ModifyBioViewController
        modifyBioVC.existingBio = bioLabel.text
        modifyBioVC.complitionHandler = { bio in
            self.modifyBio.onNext(bio)
        }
        self.present(modifyBioVC, animated: true, completion: nil)
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
