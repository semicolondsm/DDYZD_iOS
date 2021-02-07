//
//  FeedTableViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/07.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var clubProfileImageView: UIImageView!
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var uploadAt: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var flagNum: NSLayoutConstraint!
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
