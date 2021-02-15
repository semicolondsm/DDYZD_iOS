//
//  CluListTableViewController.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/21.
//

import UIKit

import RxCocoa
import RxSwift
import Kingfisher

class ClubListTableViewController: UIViewController {

    public var clubTag: ClubListCategory = .all
    
    @IBOutlet weak var ClubListTable: UITableView!
    
    private let viewModel = ClubListTableViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        registerCell()
        bind()
    }
    
    func bind(){
        let input = ClubListTableViewModel.input(
            clubTag: clubTag,
            selectIndexPath: ClubListTable.rx.itemSelected.asSignal()
        )
        let output = viewModel.transform(input)
        
        ClubListTable.rx.itemSelected.subscribe(onNext: { indexPath in
            self.ClubListTable.deselectRow(at: indexPath, animated: true)
        })
        .disposed(by: disposeBag)
        
        output.clubList.bind(to: ClubListTable.rx.items(cellIdentifier:
                                                            "ClubListTableViewCell", cellType: ClubListTableViewCell.self)){ row, item, cell in
            cell.clubNameLable.text = item.clubname
            cell.clubDescription.text = item.clubdescription
            cell.clubProfileImageView.kf.setImage(with: URL(string: "https://api.semicolon.live/file/\(item.clubimage)"))
        }
        .disposed(by: disposeBag)
        
        output.selectedClubID.asObservable().subscribe(onNext: { clubID in
            self.goClubDetailView(clubID)
        })
        .disposed(by: disposeBag)
        
    }
    
    func goClubDetailView(_ clubID: Int){
        self.navigationController?.navigationBar.shadowImage = nil
        let vc = UIStoryboard.init(name: "Club", bundle: nil).instantiateViewController(withIdentifier: "ClubDetailViewController") as! ClubDetailViewController
        vc.clubID = clubID
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

//MARK:- table view
extension ClubListTableViewController {
    
    func setTableView(){
        ClubListTable.separatorStyle = .none
    }
    
    func registerCell() {
        let nib = UINib(nibName: "ClubListTableViewCell", bundle: nil)
        ClubListTable.register(nib, forCellReuseIdentifier: "ClubListTableViewCell")
        ClubListTable.rowHeight = 80
    }
}
