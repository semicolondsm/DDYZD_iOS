//
//  FeedWithMediaTableViewCell.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/07.
//

import UIKit
import RxSwift
import WebKit

class FeedWithMediaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clubProfileImageView: UIImageView!
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var uploadAt: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var flagNum: UILabel!
    @IBOutlet weak var MenuBtn: UIButton!
    @IBOutlet weak var flagBtn: UIButton!
    @IBOutlet weak var mediaWKView: WKWebView!
    
    public var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setUI() {
        clubProfileImageView.circleImage()
    }

    func bind(item: FeedModel){
        let URL = "https://semicolondsm.xyz/mobile/feedslide?id=\(item.feedId)"
        let request: URLRequest = URLRequest.init(url: NSURL.init(string: URL)! as URL, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
        mediaWKView.load(request)
        mediaWKView.scrollView.isScrollEnabled = false
        clubName.text = item.clubName
        content.text = item.content
        flagBtn.isSelected = item.flag
        flagNum.text = String(item.flags)
    }
}
