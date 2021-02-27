//
//  ChatListTableViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/24.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var clubProfileImageView: UIImageView!
    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var unwatchedSignView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setUI(){
        clubProfileImageView.layer.cornerRadius = clubProfileImageView.frame.height/2
        unwatchedSignView.layer.cornerRadius = unwatchedSignView.frame.height/2
    }
    
    func bind(item: Room){
        clubProfileImageView.kf.setImage(with: URL(string: item.image))
        clubNameLabel.text = item.name
        whenLabel.dateLabel(item.lastdate ?? "")
        lastMessageLabel.text = "• " + (item.lastmessage ?? "")
        unwatchedSignView.isHidden = item.isread
        if item.isread {
            lastMessageLabel.textColor = #colorLiteral(red: 0.7215067744, green: 0.7216095924, blue: 0.7214744687, alpha: 1)
        } else {
            lastMessageLabel.textColor = .black
        }
    }

}
