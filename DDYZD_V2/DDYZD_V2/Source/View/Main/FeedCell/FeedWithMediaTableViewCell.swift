//
//  FeedWithMediaTableViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/07.
//

import UIKit

class FeedWithMediaTableViewCell: UITableViewCell {

    @IBOutlet weak var clubProfileImageView: UIImageView!
    @IBOutlet weak var clubNameLable: UILabel!
    @IBOutlet weak var uploadAtLable: UILabel!
    @IBOutlet weak var conectLable: UILabel!
    @IBOutlet weak var flagNumLable: UILabel!
    @IBOutlet weak var MenuBtn: UIButton!
    @IBOutlet weak var flagBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setUI() {
        clubProfileImageView.layer.cornerRadius = 30
    }

}
