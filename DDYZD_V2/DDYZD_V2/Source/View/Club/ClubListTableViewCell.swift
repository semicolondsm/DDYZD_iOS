//
//  ClubListTableViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/23.
//

import UIKit

class ClubListTableViewCell: UITableViewCell {

    @IBOutlet weak var clubProfileImageView: UIImageView!
    @IBOutlet weak var clubNameLable: UILabel!
    @IBOutlet weak var clubDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUI() {
        clubProfileImageView.layer.cornerRadius = 50
    }
}
