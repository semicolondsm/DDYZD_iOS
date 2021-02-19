//
//  BelongClubCollectionViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/19.
//

import UIKit

class BelongClubCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var clubProfileImage: UIImageView!
    @IBOutlet weak var clubNameLabel: UILabel!
    
    override func awakeFromNib() {
        
    }
    
    func setUI(){
        clubProfileImage.circleImage()
    }
}
