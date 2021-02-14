//
//  SubClass.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/14.
//

import UIKit

class clubBackImage: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
}
