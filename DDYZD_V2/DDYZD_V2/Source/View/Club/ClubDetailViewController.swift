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
    
    private let viewModel = ClubDetailViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        bind()
    }
    
    func bind() {
        
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.standardAppearance.shadowColor = .gray
        navigationController?.navigationBar.standardAppearance.backgroundColor = .white
        self.title = String(clubID)
    }

}
