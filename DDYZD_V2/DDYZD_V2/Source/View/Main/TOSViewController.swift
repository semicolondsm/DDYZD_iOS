//
//  File.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/03/07.
//

import UIKit

import WebKit
import RxSwift
import RxCocoa

class TOSViewController: UIViewController {
    
    @IBOutlet weak var TOSwkview: WKWebView!
    @IBOutlet weak var nextBtn: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        setUI()
        setTOSwkview()
        bind()
    }
    
    func setUI(){
        self.isModalInPresentation = true
        TOSwkview.layer.borderWidth = 0.5
        TOSwkview.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        TOSwkview.layer.cornerRadius = 10
    }
    
    func bind() {
        nextBtn.rx.tap.subscribe(onNext: {
            UserDefaults.standard.set(true, forKey: "isAgreeTOS")
            self.dismiss(animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
    }
    
    func setTOSwkview(){
        let url = "https://semicolondsm.github.io/DDYZD_TOS/"
        let request = URLRequest(url: URL(string: url)!)
        
        TOSwkview.load(request)
    }
    
}
