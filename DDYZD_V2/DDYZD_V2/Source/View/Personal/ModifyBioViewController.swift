//
//  ModifyBioViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/22.
//

import UIKit

class ModifyBioViewController: UIViewController {

    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

    func setUI(){
        bioTextView.layer.borderWidth = 0.5
        bioTextView.layer.borderColor = #colorLiteral(red: 0.7960784314, green: 0.79220891, blue: 0.7920084596, alpha: 1)
        bioTextView.layer.cornerRadius = 20
        confirmBtn.layer.cornerRadius = 20
    }
}
