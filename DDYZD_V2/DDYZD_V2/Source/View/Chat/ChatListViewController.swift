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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

}
