//
//  ClubListViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/21.
//

import UIKit
import Parchment

class ClubListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setTopTabbar()
    }
    

    func setTopTabbar(){
        let storyboard = UIStoryboard(name: "Club", bundle: nil)
        let firstVC = storyboard.instantiateViewController(withIdentifier: "CluListTableViewController") as! CluListTableViewController
        firstVC.title = "웹"
        let secondVC = storyboard.instantiateViewController(withIdentifier: "CluListTableViewController") as! CluListTableViewController
        secondVC.title = "앱"
        
        let pagingViewController = PagingViewController(viewControllers: [
            firstVC,
            secondVC
        ])
        
        // Make sure you add the PagingViewController as a child view
        // controller and contrain it to the edges of the view.
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
    }

}
