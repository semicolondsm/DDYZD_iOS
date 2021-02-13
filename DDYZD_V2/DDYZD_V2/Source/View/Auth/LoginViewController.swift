//
//  LoginViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/19.
//

import UIKit

import AuthenticationServices
import DSMSDK
import RxCocoa
import RxSwift
import WebKit

class LoginViewController: UIViewController {

    public var didJustBrowsingBtnTaped: (()->Void)?
    public var didSuccessLogin: (()->Void)?
    
    @IBOutlet weak var justBrowsingBtn: UIButton!
    @IBOutlet weak var introduceWebView: WKWebView!
    @IBOutlet weak var DSMAuthProvider: UIStackView!
    let DSMAuthBtn = UIButton()
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setIntroduceWebView()
        setDSMAtuhLoginBtn()
        bind()
    }
    
    func bind(){
        let input = LoginViewModel.input.init(vc: self, loginWithDSMAuthBtnDriver: DSMAuthBtn.rx.tap.asDriver())
        let output = viewModel.transform(input)
        
        justBrowsingBtn.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true){
                if let closer = self.didJustBrowsingBtnTaped {
                    closer()
                }
            }
        })
        .disposed(by: disposeBag)
        
        output.result.subscribe(onNext:{ error in
            print(error)
        }, onCompleted:{
            self.dismiss(animated: true)
            if let closer = self.didSuccessLogin {
                closer()
            }
        })
        .disposed(by: disposeBag)
    }
    
    func setDSMAtuhLoginBtn(){
        DSMAuthBtn.setBackgroundImage(UIImage(named: "DSMAuthLoginBtn"), for: .normal)
        self.DSMAuthProvider.addArrangedSubview(DSMAuthBtn)
    }
    
    func setIntroduceWebView(){
        let url = "https://semicolondsm.xyz/mobile/loginslide"
        let request = URLRequest(url: URL(string: url)!)
        
        introduceWebView.load(request)
        introduceWebView.scrollView.isScrollEnabled = false
    }

}
