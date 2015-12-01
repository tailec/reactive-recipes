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
    
    
    let searchBar = UISearchBar()
    let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: nil)
    let tableView = UITableView()
    
    private let viewModel: MainViewModel
    private let disposeBag = DisposeBag()
    
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
        bindViewModel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.active = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.active = false
    }
    

    func bindViewModel() {
        
        viewModel.searchTextObservable = searchBar.rx_text.asObservable()
       /*
        _ = viewModel.title.subscribeNext { [unowned self] title in
            print("xx")
            self.title = title
        }
        .addDisposableTo(disposeBag)
        */
        
        _ = viewModel.contentChangesObservable.debug().bindTo(tableView.rx_itemsWithCellFactory) {
            (tv: UITableView, index, item: Item) in
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            let cell = tv.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath) 
            cell.textLabel!.text = item.content
            cell.backgroundColor = item.done as! Bool ? UIColor.lightGrayColor() : UIColor.whiteColor()
            return cell as UITableViewCell
        }
        .addDisposableTo(disposeBag)

        
        _ = tableView.rx_itemSelected.subscribeNext { [unowned self] indexPath in
            self.viewModel.selectItemAtIndexPath(indexPath)
        }
        
        _ = tableView.rx_itemDeleted.subscribeNext { [unowned self] indexPath in
            self.viewModel.removeItemAtIndexPath(indexPath)
        }
        
        _ = addBarButtonItem.rx_tap.subscribeNext { [unowned self] _ in
            let addViewController = AddViewController(viewModel: self.viewModel.addViewModel())
            let navigationController = UINavigationController(rootViewController: addViewController)
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
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
        
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
}

