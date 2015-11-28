//
//  MainViewController.swift
//  reactive-recipe-2
//
//  Created by krawiecp on 28/11/2015.
//  Copyright © 2015 Pawel Krawiec. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    let viewModel: MainViewModel
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    let disposeBag = DisposeBag()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("initWithCoder not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindRx()
    }
    
    func bindRx() {
        _ = viewModel.title.driveNext { [unowned self] title in
            self.title = title
        }
        .addDisposableTo(disposeBag)
        
        _ = viewModel.items.bindTo(tableView.rx_itemsWithCellFactory) {
            (tv: UITableView, index, item: Item) in
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            let cell = tv.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath) 
            cell.textLabel!.text = item.content
            return cell as UITableViewCell
        }
        .addDisposableTo(disposeBag)
    }
    
    func initUI() {
        let views = [
            "searchBar" : searchBar,
            "tableView" : tableView
        ]
        
        for (_, subview) in views {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        
        self.view.addConstraint(NSLayoutConstraint(item: searchBar, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[searchBar][tableView]|", options: [], metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[searchBar]|", options: [], metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: [], metrics: nil, views: views))
        
        automaticallyAdjustsScrollViewInsets = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")

    }
}
