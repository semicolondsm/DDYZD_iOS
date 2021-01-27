//
//  ChatListViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/25.
//

import UIKit

class ChatListViewController: UIViewController {

    @IBOutlet weak var ChatListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
    }
    
    func setNavigationBar(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

}
