//
//  OperatorViewController.swift
//  rxswift-basic
//
//  Created by 강한결 on 7/30/24.
//

import UIKit

import RxSwift
import RxCocoa

final class OperatorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        Observable.repeatElement("d")
            .take(10)
            .subscribe {
                print($0)
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: DisposeBag()) // deinit
    }
    
    
    /**
     pickerview, tableview, uiswitch, uitextfield, uibutton
     just, of, from, take
     */
    
}
