//
//  ClubMemberCollectionViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/21.
//

import UIKit

import Kingfisher


class ClubMemberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memberProfileImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var isHeaderLabel: UILabel!
    
    override func awakeFromNib() {
        setUI()
    }
    
    func setUI(){
        isHeaderLabel.isHidden = true
        memberProfileImage.circleImage()
    }
}
