//
//  OthersChatTableViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/24.
//

import UIKit

class OthersChatTableViewCell: UITableViewCell {

    @IBOutlet weak var othersProfileImage: UIImageView!
    @IBOutlet weak var chatCellView: UIView!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var chatAtLabel: UILabel!
    
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
        othersProfileImage.circleImage()
        chatCellView.layer.borderWidth = 1
        chatCellView.layer.borderColor = #colorLiteral(red: 0.874435842, green: 0.8745588064, blue: 0.8743970394, alpha: 1)
        chatCellView.layer.cornerRadius = 20
    }

}
