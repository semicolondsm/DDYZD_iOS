//
//  ChatViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/19.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var movingView: UIView!
    @IBOutlet weak var textInputView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var chatTableBottomConstraint: NSLayoutConstraint!
    
    private var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setMessageTextField()
        addKeyboardNotification()
    }

}

//MARK:- UI
extension ChatViewController {
    func setUI(){
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
    }
}
