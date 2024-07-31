//
//  UserViewController.swift
//  rxswift-basic
//
//  Created by 강한결 on 7/31/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class UserViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        generateView()
        testBehaviorSubject()
    }
    
    private func generateView() {
        let nickname = UITextField()
        let button = UIButton()
        
        let placeholder = BehaviorSubject(value: "")
        [nickname, button].forEach {
            view.addSubview($0)
        }
        
        nickname.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(34)
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(nickname.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        nickname.textAlignment = .center
        nickname.borderStyle = .roundedRect
        
        button.backgroundColor = .purple
        button.setTitle("버튼", for: .normal)
        
        placeholder
            .bind(with: self, onNext: { owner, text in
                nickname.placeholder = text
            })
            .disposed(by: disposeBag)
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                // 뭔가 값을 바꿀 때, =을 사용하지 않음
                // 값을 바꾸는 것 역시 이벤트를 observable이 인식할 수 있게하는 것이기 때문에
                // 이벤트 전달이다.
                placeholder.onNext("바꾸셈 \(Int.random(in: 0...12312))")
            }
            .disposed(by: disposeBag)
    }
    
    private func testBehaviorSubject() {
        let behavior = BehaviorSubject(value: 3) // 3을 보낼 수도, 바뀐 값을 가져올 수도 있다. (초기값 반드시 필요)
        let publish = PublishSubject<Int>() // 초기 타입만 지정해주면 됨
        
        publish.onNext(1)
        publish.onNext(2)

        publish
            .subscribe { value in
                print(value)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        publish.onNext(100)
        publish.onCompleted()
        publish.onNext(101)
        
    }
}
