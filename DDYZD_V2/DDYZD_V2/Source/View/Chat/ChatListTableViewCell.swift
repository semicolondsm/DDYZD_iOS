//
//  ChatListTableViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/24.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var clubProfileImageView: UIImageView!
    @IBOutlet weak var clubNameLable: UILabel!
    @IBOutlet weak var lastMessageLable: UILabel!
    @IBOutlet weak var whenLable: UILabel!
    @IBOutlet weak var unwatchedSignView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setUI(){
        clubProfileImageView.layer.cornerRadius = clubProfileImageView.frame.height/2
        unwatchedSignView.layer.cornerRadius = unwatchedSignView.frame.height/2
    }
    
    func bind(item: ChatRoom){
        clubProfileImageView.kf.setImage(with: URL(string: "https://api.semicolon.live/file/\(item.clubimage)"))
        clubNameLable.text = item.clubname
        whenLable.dateLabel(item.lastdate ?? "")
        lastMessageLable.text = item.lastmessage
    }

}
