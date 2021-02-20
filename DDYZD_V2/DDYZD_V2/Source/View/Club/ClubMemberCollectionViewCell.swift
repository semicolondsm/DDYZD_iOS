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
    
    func bind(index: Int, item: ClubMember){
        memberProfileImage.kf.setImage(with: URL(string: item.profile_image))
        memberNameLabel.text = item.user_name
        if index == 0 {
            isHeaderLabel.isHidden = false
        }
    }
}
