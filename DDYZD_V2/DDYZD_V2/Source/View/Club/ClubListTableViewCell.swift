//
//  ClubListTableViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/23.
//

import UIKit

class ClubListTableViewCell: UITableViewCell {

    @IBOutlet weak var clubProfileImageView: UIImageView!
    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var clubDescription: UILabel!
    @IBOutlet weak var recruitmentIndicator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }

    func setUI() {
        clubProfileImageView.layer.cornerRadius = 30
        recruitmentIndicator.isHidden = true
    }
}
