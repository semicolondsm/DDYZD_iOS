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
    
    let socket = SocketIOManager("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        setUI()
        bind()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        loadList.accept(())
        
        socket.establishConnection()
        socket.socket.on("test") { (data, ack) in
            print(data)
        }
        socket.socket.emit("test", ["qwer":"qwer"])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        socket.closeConnection()
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
            self.moveLogin()
        })
        .disposed(by: disposeBag)
        
        output.chatList.bind(to: ChatListTable.rx.items(cellIdentifier: "ChatListTableViewCell", cellType: ChatListTableViewCell.self)){ row, item, cell in
            cell.clubProfileImageView.kf.setImage(with: URL(string: "https://api.semicolon.live/file/\(item.clubimage)"))
            cell.clubNameLable.text = item.clubname
            cell.lastMessageLable.text = item.lastmessage
        }
        .disposed(by: disposeBag)
        
    }
    
    func registerCell() {
        let nib = UINib(nibName: "ChatListTableViewCell", bundle: nil)
        ChatListTable.register(nib, forCellReuseIdentifier: "ChatListTableViewCell")
        ChatListTable.rowHeight = 80
    }

}
