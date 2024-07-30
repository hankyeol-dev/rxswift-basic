//
//  ViewController.swift
//  rxswift-basic
//
//  Created by 강한결 on 7/30/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    let tableView = UITableView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])
        
        // observer에 observable 등록
        // bind로 구독
        items
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
  
        Observable
            .zip(
                tableView.rx.itemSelected,
                tableView.rx.modelSelected(String.self)
            )
            .bind { value in
                print(value.0, value.1)
            }
            .disposed(by: disposeBag)
        
        
        
//        testJust()
//        testFrom()
//        testInterval()
    }
    
    func testJust() {
        Observable
            .just([1,2,3,4,5]) // finite observable stream
            .subscribe { value in
                print(value)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("completed!")
            } onDisposed: { // unsubscribe
                print("disposed!")
            }
            .disposed(by: disposeBag)
    }
    
    func testFrom() {
        Observable
            .from([1,2,3,4,5]) // finite observable stream
            .subscribe { value in
                print(value)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("completed!")
            } onDisposed: {
                print("disposed!")
            }
            .disposed(by: disposeBag)
    }
    
    func testInterval() {
        Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance) // infinite observable stream
            .subscribe { value in
                print(value)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("completed!") // infinite 하기 때문에 호출 안되고, 앱이 꺼지기 전까지 이벤트가 계속 메모리에 누적
            } onDisposed: { // unsubscribe
                print("disposed!")
            }
            .disposed(by: disposeBag)
    }
}

