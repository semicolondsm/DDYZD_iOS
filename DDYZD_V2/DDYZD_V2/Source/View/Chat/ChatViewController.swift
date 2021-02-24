//
//  ChatViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/19.
//

import UIKit

import RxCocoa
import RxSwift
import Kingfisher

class ChatViewController: UIViewController {

    public var roomID: Int!
    public var userType: UserType!
    
    @IBOutlet weak var movingView: UIView!
    @IBOutlet weak var textInputView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var chatTableBottomConstraint: NSLayoutConstraint!
    
    private let  getBreakdown = PublishSubject<Void>()
    
    private let viewModel = ChatViewModel()
    private let disposeBag = DisposeBag()
    private var keyboardHeight: CGFloat!
    private let navigationBarTitile = UILabel()
    private let navigationBarImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setMessageTextField()
        setTableView()
        addKeyboardNotification()
        bind()
        getChatBreakdown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
    }
    
    func bind() {
        viewModel.roomID = self.roomID
        let input = ChatViewModel.input(getBreakdown: getBreakdown.asDriver(onErrorJustReturn: ()))
        let output = viewModel.transform(input)
        
        output.breakdown.bind(to: chatTable.rx.items) { tableView, row, item -> UITableViewCell in
            switch item.user_type {
            case .Club, .user:
                if item.user_type.rawValue == self.userType!.rawValue {
                    let cell = self.chatTable.dequeueReusableCell(withIdentifier: "MyChat") as! MyChatTableViewCell
                    
                    cell.contentLabel.text = item.msg
                    
                    return cell
                } else {
                    let cell = self.chatTable.dequeueReusableCell(withIdentifier: "OthersChat") as! OthersChatTableViewCell
                    
                    cell.contentLabel.text = item.msg
                    cell.chatAtLabel.dateLabel(item.created_at)
                    
                    return cell
                }
            case .Apply:
                let cell = self.chatTable.dequeueReusableCell(withIdentifier: "ApplyChatHelper") as! ApplyChatHelperTableViewCell
                
                cell.titleLabel.text = item.title
                cell.contentLabel.text = item.msg
                cell.whenLabel.dateLabel(item.created_at)
                cell.sendScheduleBtn.isHidden = self.userType! == .ClubHead ? false : true
                
                return cell
            case .Schedule:
                let cell = self.chatTable.dequeueReusableCell(withIdentifier: "ScheduleChatHelper") as! ScheduleChatHelperTableViewCell
                
                cell.titleLabel.text = item.title
                cell.contentLabel.text = item.msg
                cell.whenLabel.dateLabel(item.created_at)
                
                return cell
            case .Result:
                let cell = self.chatTable.dequeueReusableCell(withIdentifier: "ResultChatHelper") as! ResultChatHelperTableViewCell
                
                cell.titileLabel.text = item.title
                cell.contentLabel.text = item.msg
                cell.whenLabel.dateLabel(item.created_at)
                cell.confirmationBtn.isHidden = self.userType! == .Volunteer ? false : true
                
                return cell
            }
        }
        .disposed(by: disposeBag)
    }
    
    func getChatBreakdown() {
        getBreakdown.onNext(())
    }

}

//MARK:- UI
extension ChatViewController {
    func setUI(){
        
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 35))
        
        navigationBarImage.translatesAutoresizingMaskIntoConstraints = false
        navigationBarImage.layer.cornerRadius = 17.5
        container.addSubview(navigationBarImage)
        
        navigationBarTitile.font = navigationBarTitile.font.withSize(20)
        navigationBarTitile.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(navigationBarTitile)

        let leftButtonWidth: CGFloat = 35 // left padding
        let rightButtonWidth: CGFloat = 75 // right padding
        let width = view.frame.width - leftButtonWidth - rightButtonWidth
        let offset = (rightButtonWidth - leftButtonWidth) / 2
        
        NSLayoutConstraint.activate([
            navigationBarImage.topAnchor.constraint(equalTo: container.topAnchor),
            navigationBarImage.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            navigationBarImage.widthAnchor.constraint(equalToConstant: container.frame.height),
            navigationBarImage.heightAnchor.constraint(equalToConstant: container.frame.height),
            navigationBarImage.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: -(width/2)),
            navigationBarTitile.topAnchor.constraint(equalTo: container.topAnchor),
            navigationBarTitile.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            navigationBarTitile.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: -offset+35+8),
            navigationBarTitile.widthAnchor.constraint(equalToConstant: width)
        ])
        self.navigationItem.titleView = container
    }
}

//MARK:- Keyboard event
extension ChatViewController {
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow),
          name: UIResponder.keyboardWillShowNotification,
          object: nil
        )
        
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide),
          name: UIResponder.keyboardWillHideNotification,
          object: nil
        )
      }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
        let window = UIApplication.shared.windows[0]
        let bottomPadding = window.safeAreaInsets.bottom
        let keybaordRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keybaordRectangle.height
        movingView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight+bottomPadding)
        chatTableBottomConstraint.constant = 60+keyboardHeight-bottomPadding
      }
    }
      
    @objc private func keyboardWillHide(_ notification: Notification) {
        movingView.transform = .identity
        chatTableBottomConstraint.constant = 60
    }
}

//MARK:- TextFiled
extension ChatViewController: UITextFieldDelegate {
    func setMessageTextField(){
        messageTextField.delegate = self
        textInputView.layer.borderWidth = 1
        textInputView.layer.borderColor = #colorLiteral(red: 0.874435842, green: 0.8745588064, blue: 0.8743970394, alpha: 1)
        textInputView.layer.cornerRadius = 22
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK:- TableView
extension ChatViewController: UITableViewDelegate {
    func setTableView(){
        chatTable.delegate = self
        chatTable.separatorStyle = .none
        registerCell()
    }
    
    func registerCell() {
        let myChat = UINib(nibName: "MyChat", bundle: nil)
        chatTable.register(myChat, forCellReuseIdentifier: "MyChat")
        let othersChat = UINib(nibName: "OthersChat", bundle: nil)
        chatTable.register(othersChat, forCellReuseIdentifier: "OthersChat")
        let applyChatHelper = UINib(nibName: "ApplyChatHelper", bundle: nil)
        chatTable.register(applyChatHelper, forCellReuseIdentifier: "ApplyChatHelper")
        let scheduleChatHelper = UINib(nibName: "ScheduleChatHelper", bundle: nil)
        chatTable.register(scheduleChatHelper, forCellReuseIdentifier: "ScheduleChatHelper")
        let resultChatHelper = UINib(nibName: "ResultChatHelper", bundle: nil)
        chatTable.register(resultChatHelper, forCellReuseIdentifier: "ResultChatHelper")
    }
}
