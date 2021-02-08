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

}
