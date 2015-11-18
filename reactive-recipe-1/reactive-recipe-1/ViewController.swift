//
//  ViewController.swift
//  reactive-recipe-1
//
//  Created by krawiecp on 17/11/2015.
//  Copyright © 2015 Pawel Krawiec. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let validUsernameObservable = usernameTextField.rx_text.map {
           $0.characters.count > 5
        }.distinctUntilChanged()
        
        let validPasswordObservable = passwordTextField.rx_text.map {
           $0.characters.count > 5
        }.distinctUntilChanged()
        
        validUsernameObservable.subscribeNext { value in
            print(value)
        }
        
        validUsernameObservable.map {
            $0 ? UIColor.greenColor() : UIColor.whiteColor()
        }
        .subscribeNext {
            self.usernameTextField.backgroundColor = $0
        }
        
        validPasswordObservable.map {
            $0 ? UIColor.greenColor() : UIColor.whiteColor()
            
        }
        .subscribeNext {
                self.passwordTextField.backgroundColor = $0
        }
        
        combineLatest(validUsernameObservable, validPasswordObservable) {
            $0 && $1
        }.bindTo(loginButton.rx_enabled)
        
        func parseLogin() -> Observable<String> {
            return create { observer in
                PFUser.logInWithUsernameInBackground(self.usernameTextField.text!, password: self.passwordTextField.text!) { user, error in
                    observer.onNext(user?.username ?? "Try again!")
                    observer.onCompleted()
                }
                return NopDisposable.instance
            }
            
        }
        loginButton.rx_tap.flatMap {
            parseLogin()
        }
        .subscribeNext {
            let alert = UIAlertController(title: $0, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

