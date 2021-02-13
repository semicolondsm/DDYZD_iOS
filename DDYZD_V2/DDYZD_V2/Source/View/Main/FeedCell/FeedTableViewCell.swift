//
//  FeedTableViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/07.
//

import UIKit
import RxSwift

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clubProfileImageView: UIImageView!
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var uploadAt: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var flagNum: UILabel!
    @IBOutlet weak var MenuBtn: UIButton!
    @IBOutlet weak var flagBtn: UIButton!
    
    public var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setUI() {
        clubProfileImageView.circleImage()
    }

    func bind(item: FeedModel) {
        clubProfileImageView.kf.setImage(with: URL(string: "https://api.semicolon.live/file/\(item.profileImage)"))
        clubName.text = item.clubName
        uploadAt.dateLabel(item.uploadAt)
        content.text = item.content
        flagBtn.isSelected = item.flag
        flagNum.text = String(item.flags)
    }
}
