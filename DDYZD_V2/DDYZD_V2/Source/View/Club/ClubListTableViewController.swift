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
            cell.clubNameLabel.text = item.clubname
            cell.clubDescription.text = item.clubdescription
            cell.clubProfileImageView.kf.setImage(with: kfImageURL(url: item.clubimage, type: .half))
            cell.recruitmentIndicator.isHidden = !item.clubrecruitment
        }
        .disposed(by: disposeBag)
        
        output.selectedClubID.asObservable().subscribe(onNext: { clubID in
            self.goClubDetailView(clubID)
        })
        .disposed(by: disposeBag)
        
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
