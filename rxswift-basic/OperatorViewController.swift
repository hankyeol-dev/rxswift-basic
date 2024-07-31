//
//  OperatorViewController.swift
//  rxswift-basic
//
//  Created by 강한결 on 7/30/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class OperatorViewController: UIViewController {
    var disposeBag = DisposeBag()
    // rootVC에 있는한 disposeBag은 계속 메모리에 존재함
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    
        operator1()
        operator2()
    }
    
    deinit {
        print("OperatorVC deinit")
    }

    private func repeatOperator() {
        Observable.repeatElement("d")
            .take(10)
            .subscribe {
                print($0)
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: DisposeBag()) // deinit
    }
    
    private func operator1() {
        let list = [1, 2, 3, 4, 5, 6, 7]
        let label = UILabel()
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(24)
        }
        
        Observable
            .of(list)
            .map { String($0.reduce(0) { partialResult, value in
                partialResult + value
            }) }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        let increment = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        let observer = increment.subscribe { value in
            print(value)
        }
        
        observer.disposed(by: disposeBag)
    }
    
    private func operator2() {
        let list = [1, 2, 3, 4, 5, 6, 7]
        let label = UILabel()
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(44)
            make.height.equalTo(24)
        }
        
        Observable
            .of(list)
            .map { String($0.reduce(0) { partialResult, value in
                partialResult + value
            }) }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        let increment = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        let observer = increment.subscribe { value in
            print(value)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            observer.dispose() // 비동기로 dispose 시점 제어를 해줄 수 있겠다.
        }
    }
}
