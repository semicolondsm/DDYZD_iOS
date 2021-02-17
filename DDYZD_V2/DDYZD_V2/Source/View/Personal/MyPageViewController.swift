//
//  MyPageViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/17.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gcnLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var githubLinkBtn: UIButton!
    @IBOutlet weak var belongClubCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setNavigationBar()
    }
    
    func openInSafari(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:])
        }
    }

}

//MARK:- UI
extension MyPageViewController {
    
    func setUI(){
        profileImage.circleImage()
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 44.0))

        let label = UILabel(frame: CGRect(x: -40, y: 0.0, width: 150.0, height: 44.0))
        label.text = "마이 페이지"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = NSTextAlignment.right
        customView.addSubview(label)

        let leftButton = UIBarButtonItem(customView: customView)
        navigationItem.leftBarButtonItem = leftButton
    }
    
}
