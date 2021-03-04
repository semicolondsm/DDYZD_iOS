//
//  BelongClubCollectionViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/19.
//

import UIKit

import Kingfisher

class BelongClubCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var clubProfileImage: UIImageView!
    @IBOutlet weak var clubNameLabel: UILabel!
    
    override func awakeFromNib() {
        setUI()
    }
    
    func setUI(){
        clubProfileImage.circleImage()
    }
    
    func bind(_ item: Club) {
        clubProfileImage.kf.setImage(with: kfImageURL(url: item.club_image, type: .half))
        clubNameLabel.text = item.club_name
    }
}
