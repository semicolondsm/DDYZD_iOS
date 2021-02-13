//
//  ClubListViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/21.
//

import UIKit

import Tabman
import Pageboy

class ClubListViewController: TabmanViewController {

    private var viewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        embeddViewControllers()
        setTopTabbar()
    }
    
    func setNavigationBar(){
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 44.0))
        let label = UILabel(frame: CGRect(x: -15.0, y: 0.0, width: 150.0, height: 44.0))
        label.text = "동아리 리스트"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = NSTextAlignment.right
        customView.addSubview(label)
        
        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    func embeddViewControllers(){
        for tag in ClubListCategory.allItems {
            let vc = UIStoryboard.init(name: "Club", bundle: nil).instantiateViewController(withIdentifier: "ClubListTableViewController") as! ClubListTableViewController
            vc.clubTag = tag
            viewControllers.append(vc)
        }
    }
    
    func setTopTabbar(){
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.backgroundView.style = .blur(style: .light)
        bar.indicator.tintColor = #colorLiteral(red: 0.4811326265, green: 0.1003668979, blue: 0.812384963, alpha: 1)
        bar.buttons.customize{ $0.selectedTintColor = #colorLiteral(red: 0.4811326265, green: 0.1003668979, blue: 0.812384963, alpha: 1) }
        
        addBar(bar, dataSource: self, at: .top)
        bar.layer.addBorder([.bottom], color: #colorLiteral(red: 0.7685618401, green: 0.768670857, blue: 0.7685275674, alpha: 1), width: 0.3)
    }

}

extension ClubListViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let indexViewController = viewControllers[index] as! ClubListTableViewController
        let item = TMBarItem(title: "")
        item.title = indexViewController.clubTag.title() + "        "
        
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
