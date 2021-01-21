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

    @IBOutlet weak var appleAuthProvider: UIStackView!
    @IBOutlet weak var DSMAuthProvider: UIStackView!
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    func bind(){
        let DSMAuthBtn = UIButton()
        DSMAuthBtn.setBackgroundImage(UIImage(named: "DSMAuthLoginBtn"), for: .normal)
        
        let appleAuthBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .whiteOutline)
        appleAuthBtn.cornerRadius = 50
        
        self.DSMAuthProvider.addArrangedSubview(DSMAuthBtn)
        self.appleAuthProvider.addArrangedSubview(appleAuthBtn)
        
        let input = LoginViewModel.input.init(vc: self, loginWithDSMAuthBtnDriver: DSMAuthBtn.rx.tap.asDriver())
        let output = viewModel.transform(input)
    }
    
    

}
