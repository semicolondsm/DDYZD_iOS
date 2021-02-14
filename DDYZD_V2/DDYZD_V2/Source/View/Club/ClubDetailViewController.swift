//
//  ClubDetailViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/04.
//

import UIKit

import RxCocoa
import RxSwift

class ClubDetailViewController: UIViewController {

    public var clubID = 0
    
    @IBOutlet weak var feedTable: UITableView!
    @IBOutlet weak var clubBackImage: UIImageView!
    @IBOutlet weak var clubProfileImgae: UIImageView!
    @IBOutlet weak var clubNameLabel: UILabel!
    
    private let viewModel = ClubDetailViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
    }
    
    func bind() {
        
    }
    
    func setUI(){
        clubProfileImgae.circleImage()
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.standardAppearance.shadowColor = .gray
        navigationController?.navigationBar.standardAppearance.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4811326265, green: 0.1003668979, blue: 0.812384963, alpha: 1)
    }

}

