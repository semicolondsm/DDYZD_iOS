//
//  ScheduleChatHelperTableViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/24.
//

import UIKit

class ScheduleChatHelperTableViewCell: UITableViewCell {

    @IBOutlet weak var helperCellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setUI(){
        helperCellView.layer.borderWidth = 1
        helperCellView.layer.borderColor = #colorLiteral(red: 0.874435842, green: 0.8745588064, blue: 0.8743970394, alpha: 1)
        helperCellView.layer.cornerRadius = 10
    }

}
