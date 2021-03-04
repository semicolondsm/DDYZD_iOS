//
//  ModifyBioViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/22.
//

import UIKit

import RxCocoa
import RxSwift

class ModifyBioViewController: UIViewController {

    public var existingBio: String?
    public var complitionHandler: ((String)->Void)!
    
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
    
    func bind() {
        confirmBtn.rx.tap.subscribe(onNext: {
            self.complitionHandler(self.bioTextView.text!)
            self.dismiss(animated: true)
        })
        .disposed(by: disposeBag)
    }

    func setUI(){
        bioTextView.text = existingBio ?? ""
        bioTextView.layer.borderWidth = 0.5
        bioTextView.layer.borderColor = #colorLiteral(red: 0.7960784314, green: 0.79220891, blue: 0.7920084596, alpha: 1)
        bioTextView.layer.cornerRadius = 20
        confirmBtn.layer.cornerRadius = 20
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
}
