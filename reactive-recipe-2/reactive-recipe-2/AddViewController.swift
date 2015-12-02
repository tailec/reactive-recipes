//
//  AddViewController.swift
//  reactive-recipe-2
//
//  Created by krawiecp on 29/11/2015.
//  Copyright © 2015 Pawel Krawiec. All rights reserved.
//

import UIKit
import CoreData
class AddViewController: UIViewController {

    var viewModel: AddViewModel
        
    let textView = UITextView()
    let cancelBarButtonItem = UIBarButtonItem()
    let doneBarButtonItem = UIBarButtonItem()
    
    init(viewModel: AddViewModel) {
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

    func bindViewModel() {
        cancelBarButtonItem.title = viewModel.cancelBarButtonItemTitle
        doneBarButtonItem.title = viewModel.doneBarButtonItemTitle
        
        _ = textView.rx_text.bindTo(viewModel.contentTextObservable)
        
        _ = self.viewModel.isContentValid.bindTo(doneBarButtonItem.rx_enabled)
        
        _ = doneBarButtonItem.rx_tap.subscribeNext { [unowned self] _ in
            self.viewModel.addItem()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        _ = cancelBarButtonItem.rx_tap.subscribeNext { [unowned self] _ in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func initUI() {
        let views = [
            "textView" : textView
        ]
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[textView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[textView]|", options: [], metrics: nil, views: views))
        
        textView.becomeFirstResponder()
        
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
}







