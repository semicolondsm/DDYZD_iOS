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

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gcnLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var githubLinkBtn: UIButton!
    @IBOutlet weak var belongClubCollectionView: UICollectionView!
    
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    
    private let getMyInfo = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        getInfo()
        setUI()
        setNavigationBar()
    }
    
    func openInSafari(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:])
        }
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
        })
        .disposed(by: disposeBag)
    }
    
    func getInfo() {
        getMyInfo.onNext(())
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
