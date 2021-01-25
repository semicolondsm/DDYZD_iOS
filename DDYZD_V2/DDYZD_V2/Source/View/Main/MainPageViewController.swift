//
//  MainPageViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/24.
//

import UIKit
import WebKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var goChatBtn: UIBarButtonItem!
    @IBOutlet weak var feedView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationbar()
    }
    
    func setWebView(){
        
    }
    
    func setNavigationbar(){
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 44.0))

        let icon = UIImageView(image: UIImage(named: "logo"))
        icon.contentMode = .scaleToFill
        icon.frame = CGRect(x: 0.0, y: 5.0, width: 30.0, height: 30.0)
        customView.addSubview(icon)

        let marginX = CGFloat(icon.frame.origin.x + icon.frame.size.width - 30)
        let label = UILabel(frame: CGRect(x: marginX, y: 0.0, width: 150.0, height: 44.0))
        label.text = "대동여지도"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = NSTextAlignment.right
        customView.addSubview(label)

        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    

}
