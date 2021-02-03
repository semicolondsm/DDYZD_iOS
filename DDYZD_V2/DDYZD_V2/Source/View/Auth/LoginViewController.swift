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

class LoginViewController: UIViewController {

    @IBOutlet weak var justBrowsingBtn: UIButton!
    @IBOutlet weak var DSMAuthProvider: UIStackView!
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    func bind(){
        justBrowsingBtn.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
        
        let DSMAuthBtn = UIButton()
        DSMAuthBtn.setBackgroundImage(UIImage(named: "DSMAuthLoginBtn"), for: .normal)
        
        self.DSMAuthProvider.addArrangedSubview(DSMAuthBtn)
        
        let input = LoginViewModel.input.init(vc: self, loginWithDSMAuthBtnDriver: DSMAuthBtn.rx.tap.asDriver())
        let output = viewModel.transform(input)
        
        output.result.subscribe(onNext:{ error in
            print(error)
        }, onCompleted:{
            self.dismiss(animated: true)
        })
        .disposed(by: disposeBag)
        
    }
    
    

}
