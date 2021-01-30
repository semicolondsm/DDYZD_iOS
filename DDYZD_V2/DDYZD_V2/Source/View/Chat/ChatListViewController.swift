//
//  ChatListViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/25.
//

import UIKit

import Alamofire
import RxCocoa
import RxSwift
import Kingfisher

class ChatListViewController: UIViewController {

    @IBOutlet weak var ChatListTable: UITableView!
    
    private let viewModel = ChatListViewModel()
    private let disposeBag = DisposeBag()
    private let loadList = BehaviorRelay<Void>(value: ())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        setUI()
    }
    
    func setNavigationBar(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.topItem?.title = ""        
    }
    
    func setUI(){
        ChatListTable.separatorStyle = .none
    }
    
    func bind(){
        let input = ChatListViewModel.input(
            loadList: loadList.asSignal(onErrorJustReturn: ())
        )
        let output = viewModel.transform(input)
        
        output.result.subscribe(onNext: { errorMessage in
            print(errorMessage)
        })
        .disposed(by: disposeBag)
    }

}
