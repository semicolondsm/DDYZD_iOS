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

    @IBOutlet weak var ClubListTable: UITableView!
    
    public var clubTag: ClubListCategory = .all
    private let viewModel = ClubListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerCell()
        bind()
    }
    
    func setUI(){
        ClubListTable.separatorStyle = .none
    }
    
    func bind(){
        let input = ClubListViewModel.input(
            clubTag: clubTag,
            selectIndexPath: ClubListTable.rx.itemSelected.asSignal()
        )
        let output = viewModel.transform(input)
        
        output.clubList.bind(to: ClubListTable.rx.items(cellIdentifier: "ClubListTableViewCell", cellType: ClubListTableViewCell.self)){ row, item, cell in
            cell.clubNameLable.text = item.clubname
            cell.clubDescription.text = item.clubdescription
            cell.clubProfileImageView.kf.setImage(with: URL(string: "https://api.semicolon.live/file/\(item.clubimage)"))
        }
        .disposed(by: disposeBag)
    }

    func registerCell() {
        let nib = UINib(nibName: "ClubListTableViewCell", bundle: nil)
        ClubListTable.register(nib, forCellReuseIdentifier: "ClubListTableViewCell")
        ClubListTable.rowHeight = 80
    }
}
