//
//  MyChatTableViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/24.
//

import UIKit

class MyChatTableViewCell: UITableViewCell {

    @IBOutlet weak var chatCellView: UIView!
    @IBOutlet weak var content: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTextView()
        setUI()
    }
    
    func setTextView(){
        content.isEditable = false
        content.dataDetectorTypes = .link
    }

    func setUI() {
        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        chatCellView.layer.cornerRadius = 20
    }
}
