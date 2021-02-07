//
//  MainPageViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/24.
//

import UIKit

import RxCocoa
import RxSwift
import WebKit


class MainPageViewController: UIViewController {
    
    @IBOutlet weak var headerWKView: WKWebView!
    @IBOutlet weak var feedTable: UITableView!
    
    private let viewModel = MainPageViewModel()
    private let disposeBag = DisposeBag()
    
    private let tokenRefresh = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHeaderWKView()
        setTableViewUI()
        bind()
        refreshToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationbar()
    }
    
    func bind() {
        let input = MainPageViewModel.input.init(tokenRefresh: tokenRefresh.asDriver(onErrorJustReturn: ()))
        let output = viewModel.transform(input)
        
        output.tokenRefreshResult.subscribe(onNext: { errorMessage in
            print(errorMessage)
        })
        .disposed(by: disposeBag)
    }
    
    func refreshToken(){
        tokenRefresh.onNext(())
    }
    
    func setNavigationbar(){
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 44.0))

        let icon = UIImageView(image: UIImage(named: "logo"))
        icon.contentMode = .scaleToFill
        icon.frame = CGRect(x: 0.0, y: 5.0, width: 30.0, height: 30.0)
        customView.addSubview(icon)

        let marginX = CGFloat(icon.frame.origin.x + icon.frame.size.width - 30)
        let label = UILabel(frame: CGRect(x: marginX, y: 0.0, width: 150.0, height: 44.0))
        label.text = "대동여지도"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = NSTextAlignment.right
        customView.addSubview(label)

        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    func setHeaderWKView() {
        let URL = "https://semicolondsm.xyz/mobile/feed"
        let request: URLRequest = URLRequest.init(url: NSURL.init(string: URL)! as URL, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
        headerWKView.load(request)
        headerWKView.scrollView.isScrollEnabled = false
    }
    
    func setTableViewUI(){
        feedTable.separatorStyle = .none
    }
    
    
}
