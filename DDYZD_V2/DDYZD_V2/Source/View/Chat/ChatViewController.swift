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
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var chatTableBottomConstraint: NSLayoutConstraint!
    
    private let enterRoom = PublishSubject<Void>()
    private let exitRoom = PublishSubject<Void>()
    private let sendMessage = PublishSubject<String>()
    private let sendApply = PublishSubject<String>()
    private let sendSchedule = PublishSubject<(String, String)>()
    private let sendResult = PublishSubject<Bool>()
    private let sendAnswer = PublishSubject<Bool>()
    
    private let viewModel = ChatViewModel()
    private let disposeBag = DisposeBag()
    private var keyboardHeight: CGFloat!
    private let navigationBarTitile = UILabel()
    private let navigationBarImage = UIImageView()
    private var majorBeingRecruited = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
        setMessageTextField()
        setTableView()
        addKeyboardNotification()
        bind()
        enterChatRoom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        exitChatRoom()
        UIApplication.topViewController()?.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward")
        UIApplication.topViewController()?.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")
    }
    
    func bind() {
        viewModel.roomID = self.roomID
        let input = ChatViewModel.input(enterRoom: enterRoom.asDriver(onErrorJustReturn: ()),
                                        exitRoom: exitRoom.asDriver(onErrorJustReturn: ()),
                                        sendMessage: sendMessage.asDriver(onErrorJustReturn: ""),
                                        sendApply: sendApply.asDriver(onErrorJustReturn: ""),
                                        sendSchedule: sendSchedule.asDriver(onErrorJustReturn: ("","")),
                                        sendResult: sendResult.asDriver(onErrorJustReturn: false),
                                        sendAnswer: sendAnswer.asDriver(onErrorJustReturn: true))
        let output = viewModel.transform(input)
        
        output.roomInfo.subscribe(onNext: { roomInfo in
            self.navigationBarImage.kf.setImage(with: kfImageURL(url: roomInfo.image, type: .all))
            self.navigationBarTitile.text = roomInfo.name
            switch roomInfo.status {
            case .Common:
                self.actionBtn.isHidden = true
                self.chatTable.tableHeaderView?.frame.size.height = 20
            case .Notificate:
                self.actionBtn.isHidden = self.userType! == .Volunteer ? false : true
                self.chatTable.tableHeaderView?.frame.size.height = self.userType! == .Volunteer ? 64 : 20
            case .Applicant:
                self.actionBtn.isHidden = true
                self.chatTable.tableHeaderView?.frame.size.height = 20
            case .Scheduled:
                self.actionBtn.isHidden = self.userType! == .ClubHead ? false : true
                self.chatTable.tableHeaderView?.frame.size.height = self.userType! == .ClubHead ? 64 : 20
            case .Resulted:
                self.actionBtn.isHidden = true
                self.chatTable.tableHeaderView?.frame.size.height = 20
            }
        })
        .disposed(by: disposeBag)
        
        output.breakdown
            .scan([], accumulator: { $1 + $0 })
            .bind(to: chatTable.rx.items) { tableView, row, item -> UITableViewCell in
            switch item.user_type {
            case .Club, .User:
                if item.user_type.rawValue == self.userType!.rawValue {
                    let cell = self.chatTable.dequeueReusableCell(withIdentifier: "MyChat") as! MyChatTableViewCell
                    
                    cell.content.delegate = self
                    cell.content.text = item.msg
                    
                    return cell
                } else {
                    let cell = self.chatTable.dequeueReusableCell(withIdentifier: "OthersChat") as! OthersChatTableViewCell
                    
                    cell.othersProfileImage.image = self.navigationBarImage.image
                    cell.content.delegate = self
                    cell.content.text = item.msg
                    cell.chatAtLabel.dateLabel(item.created_at)
                    
                    return cell
                }
            case .Apply:
                let cell = self.chatTable.dequeueReusableCell(withIdentifier: "ApplyChatHelper") as! ApplyChatHelperTableViewCell
                
                cell.titleLabel.text = item.title
                cell.contentLabel.text = item.msg
                cell.whenLabel.dateLabel(item.created_at)
                cell.sendScheduleBtn.isHidden = self.userType! == .ClubHead ? false : true
                cell.sendScheduleBtn.rx.tap.subscribe(onNext: {
                    self.presentScheduleAlert()
                })
                .disposed(by: cell.disposeBag)
                
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
                cell.confirmationBtn.isHidden = !((item.result ?? true) && (self.userType! == .Volunteer))
                cell.confirmationBtn.rx.tap.subscribe(onNext: {
                    self.presentAnswerAlert()
                })
                .disposed(by: cell.disposeBag)
                
                return cell
            case .Answer:
                let cell = self.chatTable.dequeueReusableCell(withIdentifier: "AnswerChatHelper") as! AnswerChatHelperTableViewCell
                
                cell.titleLabel.text = item.title
                cell.contentLabel.text = item.msg
                cell.whenLabel.dateLabel(item.created_at)
                
                return cell
            }
                
            
        }
        .disposed(by: disposeBag)
        
        output.majorBeingRecruited.subscribe(onNext: { majors in
            self.majorBeingRecruited = majors
        })
        .disposed(by: disposeBag)
        
        self.actionBtn.rx.tap.subscribe(onNext: {
            switch self.userType {
            case .Volunteer:
                self.presentApplyAlert()
            case .ClubHead:
                self.presentResultActionSheet()
            default:
                break
            }
        })
        .disposed(by: self.disposeBag)
        
        sendBtn.rx.tap.subscribe(onNext: {
            self.sendMessage.onNext(self.messageTextField.text!)
            self.messageTextField.text = ""
            self.sendBtn.isEnabled = false
        })
        .disposed(by: disposeBag)
        
        messageTextField.rx.text.orEmpty
            .map{
                $0 == "" ? false : true
            }
            .subscribe(onNext: {
                self.sendBtn.isEnabled = $0
            })
            .disposed(by: disposeBag)
    }
    
    func enterChatRoom() {
        enterRoom.onNext(())
    }
    
    func exitChatRoom() {
        exitRoom.onNext(())
    }

}

//MARK:- UI
extension ChatViewController {
    func setUI(){
        actionBtn.isHidden = true
        actionBtn.layer.cornerRadius = 17.5
        actionBtn.layer.shadowColor = UIColor.black.cgColor
        actionBtn.layer.masksToBounds = false
        actionBtn.layer.shadowOffset = CGSize(width: 0, height: 4)
        actionBtn.layer.shadowRadius = 5
        actionBtn.layer.shadowOpacity = 0.3
        switch userType {
        case .Volunteer: actionBtn.setTitle("지원하기", for: .normal)
        case .ClubHead: actionBtn.setTitle("결과 보내기", for: .normal)
        default: break
        }
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 35))
        
        navigationBarImage.translatesAutoresizingMaskIntoConstraints = false
        navigationBarImage.layer.masksToBounds = true
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
        actionBtn.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight+bottomPadding)
        chatTableBottomConstraint.constant = 40+keyboardHeight-bottomPadding
      }
    }
      
    @objc private func keyboardWillHide(_ notification: Notification) {
        movingView.transform = .identity
        actionBtn.transform = .identity
        chatTableBottomConstraint.constant = 40
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
        registerCell()
        chatTable.delegate = self
        chatTable.separatorStyle = .none
        chatTable.allowsSelection = false
        chatTable.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        chatTable.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: chatTable.bounds.size.width - 8.0)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ApplyChatHelperTableViewCell {
            cell.disposeBag = DisposeBag()
        }
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
        let answerChatHelper = UINib(nibName: "AnswerChatHelper", bundle: nil)
        chatTable.register(answerChatHelper, forCellReuseIdentifier: "AnswerChatHelper")
    }
}

//MARK:- Alert
extension ChatViewController {
    func presentApplyAlert() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        Observable.just(self.majorBeingRecruited).bind(to: pickerView.rx.itemTitles) { row, major in
            return major
        }.disposed(by: self.disposeBag)
        vc.view.addSubview(pickerView)
        let applyAlert = UIAlertController.init(title: "지원하기", message: "분야를 선택해주세요.", preferredStyle: .alert)
        applyAlert.setValue(vc, forKey: "contentViewController")
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            self.sendApply.onNext(self.majorBeingRecruited[pickerView.selectedRow(inComponent: 0)])
            self.actionBtn.isHidden = true
            self.chatTable.tableHeaderView?.frame.size.height = 0
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        applyAlert.addAction(confirm)
        applyAlert.addAction(cancle)
        applyAlert.view.tintColor = .black
        self.present(applyAlert, animated: true, completion: nil)
    }
    
    func presentScheduleAlert() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 50)
        let datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        datePickerView.datePickerMode = .dateAndTime
        vc.view.addSubview(datePickerView)
        let scheduleAlert = UIAlertController.init(title: "면접 일정", message: "면접 일시와 장소를 선택해주세요.", preferredStyle: .alert)
        scheduleAlert.setValue(vc, forKey: "contentViewController")
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko")
            formatter.dateFormat = "M월 d일 a h시 m분"
            self.sendSchedule.onNext((formatter.string(from: datePickerView.date),
                                      scheduleAlert.textFields![0].text!))
            self.actionBtn.setTitle("결과 보내기", for: .normal)
        }
        scheduleAlert.addTextField(){ textField in
            textField.placeholder = "면접 장소"
            textField.rx.text.orEmpty
                .map{ $0 == "" ? false : true }
                .subscribe(onNext: {
                    confirm.isEnabled = $0
                })
                .disposed(by: self.disposeBag)
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        scheduleAlert.addAction(confirm)
        scheduleAlert.addAction(cancle)
        scheduleAlert.view.tintColor = .black
        self.present(scheduleAlert, animated: true, completion: nil)
    }
    
    func presentResultActionSheet() {
        let resultActionSheet = UIAlertController.init(title: "면접 결과", message: "면접 결과를 선택해주세요.", preferredStyle: .actionSheet)
        let pass = UIAlertAction(title: "합격", style: .default) { _ in
            self.sendResult.onNext(true)
            self.actionBtn.isHidden = true
            self.chatTable.tableHeaderView?.frame.size.height = 0
        }
        let fail = UIAlertAction(title: "불합격", style: .destructive) { _ in
            self.sendResult.onNext(false)
            self.actionBtn.isHidden = true
            self.chatTable.tableHeaderView?.frame.size.height = 0
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        resultActionSheet.addAction(pass)
        resultActionSheet.addAction(fail)
        resultActionSheet.addAction(cancle)
        resultActionSheet.view.tintColor = .black
        self.present(resultActionSheet, animated: true, completion: nil)
    }
    
    func presentAnswerAlert() {
        let answerAlert = UIAlertController(title: "확정", message: "이 동아리를 확정하시겠습니까?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            self.sendAnswer.onNext(true)
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        answerAlert.addAction(cancle)
        answerAlert.addAction(confirm)
        answerAlert.view.tintColor = .black
        self.present(answerAlert, animated: true)
    }
}

// MARK:- TextView
extension ChatViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        self.openInSafari(url: URL)
        return false
    }
    
}
