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
        
        registerCell()
        setUI()
        bind()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        SocketIOManager.shared.establishConnection()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SocketIOManager.shared.closeConnection()
    }
    
    func bind(){
        let input = ChatListViewModel.input(
            loadList: loadList.asSignal(onErrorJustReturn: ()),
            selectIndexPath: ChatListTable.rx.itemSelected.asSignal()
        )
        let output = viewModel.transform(input)
        
        ChatListTable.rx.itemSelected.subscribe(onNext: { indexPath in
            self.ChatListTable.deselectRow(at: indexPath, animated: true)
        })
        .disposed(by: disposeBag)
        
        output.result.subscribe(onNext: { errorMessage in
            self.moveLogin(didJustBrowsingBtnTaped: {
                self.navigationController?.popViewController(animated: true)
            }, didSuccessLogin: {
                self.loadList.accept(())
            })
        })
        .disposed(by: disposeBag)
        
        output.chatList.bind(to: ChatListTable.rx.items(cellIdentifier: "ChatListTableViewCell", cellType: ChatListTableViewCell.self)){ row, item, cell in
            cell.bind(item: item)
        }
        .disposed(by: disposeBag)
        
        output.roomID.asObservable().subscribe(onNext: { roomID in
            self.goChatPage(roomID: roomID)
        })
        .disposed(by: disposeBag)
        
    }
    
    func registerCell() {
        let nib = UINib(nibName: "ChatListTableViewCell", bundle: nil)
        ChatListTable.register(nib, forCellReuseIdentifier: "ChatListTableViewCell")
        ChatListTable.rowHeight = 80
    }
    
    func goChatPage(roomID: Int){
        let chatSB: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        let chatVC = chatSB.instantiateViewController(identifier: "ChatViewController") as! ChatViewController
        chatVC.roomID = roomID
        self.navigationController?.pushViewController(chatVC, animated: true)
    }

}

//MARK:- UI
extension ChatListViewController {
    func setNavigationBar(){
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4811326265, green: 0.1003668979, blue: 0.812384963, alpha: 1)
        navigationItem.title = "채팅"
    }
    
    func setUI(){
        ChatListTable.separatorStyle = .none
    }
}
