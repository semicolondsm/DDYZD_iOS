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
import SwiftOverlays

class ChatListViewController: UIViewController {

    @IBOutlet weak var ChatListTable: UITableView!
        
    private let loadSections = PublishSubject<Void>()
    private let loadList = PublishSubject<Int>()
    private let deleteChat = PublishSubject<Int>()
    
    private let viewModel = ChatListViewModel()
    private let disposeBag = DisposeBag()
    private var chatSections = [String]()
    private var selectedChatSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showWaitOverlay()
        setTableView()
        setUI()
        bind()
        getChatSections()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        getChatList(section: selectedChatSection)
    }
    
    func bind(){
        let input = ChatListViewModel.input(
            loadSections: loadSections.asDriver(onErrorJustReturn: ()),
            loadList: loadList.asDriver(onErrorJustReturn: 0),
            selectIndexPath: ChatListTable.rx.itemSelected.asSignal(),
            deleteChat: deleteChat.asDriver(onErrorJustReturn: 0)
        )
        let output = viewModel.transform(input)
        
        ChatListTable.rx.itemSelected.subscribe(onNext: { indexPath in
            self.ChatListTable.deselectRow(at: indexPath, animated: true)
        })
        .disposed(by: disposeBag)
        
        
        output.result.subscribe(onNext: { isSuccess in
            if !isSuccess {
                self.moveLogin(didJustBrowsingBtnTaped: {
                    self.navigationController?.popViewController(animated: true)
                }, didSuccessLogin: {
                    self.loadList.onNext(0)
                })
            }
        })
        .disposed(by: disposeBag)
        
        output.sectionList.subscribe(onNext: { sections in
            self.removeAllOverlays()
            self.chatSections = sections
            self.setSelectSectionBarItem()
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
        
        ChatListTable.rx.itemDeleted.subscribe(onNext: { indexPath in
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.message = "이 대화를 영구적으로 삭제하시겠어요?"
            let deleteChatAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.deleteChat.onNext(indexPath.row)
            }
            let cancle = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            actionSheet.addAction(deleteChatAction)
            actionSheet.addAction(cancle)
            actionSheet.view.tintColor = .black
            self.present(actionSheet, animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
        
    }
    
    func getChatSections() {
        loadSections.onNext(())
    }
    
    func getChatList(section: Int) {
        loadList.onNext(section)
    }
    
    func goChatPage(roomID: Int){
        let chatSB: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        let chatVC = chatSB.instantiateViewController(identifier: "ChatViewController") as! ChatViewController
        chatVC.roomID = roomID
        chatVC.userType = selectedChatSection == 0 ? .Volunteer : .ClubHead
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func setSelectSectionBarItem() {
        navigationItem.rightBarButtonItem?.title = chatSections[0]+" ▾"
    }
    
    @objc func openSelectSectionActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = .black
        for section in self.chatSections {
            let action = UIAlertAction(title: section, style: .default, handler: { _ in
                self.navigationItem.rightBarButtonItem?.title = section+" ▾"
                self.selectedChatSection = self.chatSections.firstIndex(of: section)!
                self.getChatList(section: self.selectedChatSection)
            })
            actionSheet.addAction(action)
        }
        self.present(actionSheet, animated: true, completion: nil)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: navigationItem.rightBarButtonItem?.title, style: .plain, target: self, action: #selector(openSelectSectionActionSheet))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.4509803922, green: 0.4470926523, blue: 0.4469521046, alpha: 1)
    }
    
    func setUI(){
        ChatListTable.separatorStyle = .none
    }
}

//MARK:- table view
extension ChatListViewController: UITableViewDelegate {
    
    func setTableView() {
        ChatListTable.delegate = self
        registerCell()
    }
    
    func registerCell() {
        let nib = UINib(nibName: "ChatListTableViewCell", bundle: nil)
        ChatListTable.register(nib, forCellReuseIdentifier: "ChatListTableViewCell")
        ChatListTable.rowHeight = 80
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
}
