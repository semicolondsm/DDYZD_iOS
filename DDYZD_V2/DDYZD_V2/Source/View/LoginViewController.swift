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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupProviserLoginViews()
    }
    
    func setupProviserLoginViews(){
        let DSMAuthBtn = UIButton()
        DSMAuthBtn.setBackgroundImage(UIImage(named: "DSMAuthLoginBtn"), for: .normal)
        
        let appleAuthBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .whiteOutline)
        appleAuthBtn.cornerRadius = 50
        
        self.DSMAuthProvider.addArrangedSubview(DSMAuthBtn)
        self.appleAuthProvider.addArrangedSubview(appleAuthBtn)
    }

}
