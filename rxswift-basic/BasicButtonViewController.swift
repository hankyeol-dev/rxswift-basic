//
//  BasicButtonViewController.swift
//  rxswift-basic
//
//  Created by 강한결 on 7/30/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class BasicButtonViewController: UIViewController {
    
    private let button = UIButton() // observable
    private let label = UILabel() // observer
    private let textField = UITextField()
    private let secondLabel = UILabel()
    
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(button)
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(secondLabel)
        
        button.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(32)
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(32)
        }
        
        button.backgroundColor = .red
        button.setTitle("버튼", for: .normal)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .purple
        textField.borderStyle = .line
        secondLabel.textAlignment = .center
        secondLabel.textColor = .white
        secondLabel.backgroundColor = .purple
        
//        buttonHandler()
        fieldHandler()
    }
}

extension BasicButtonViewController {
    func buttonHandler() {
        //        button.rx.tap
        //            .withUnretained(self) // arc
        //            .subscribe { _ in
        //                self.label.text = "클릭함"
        //            }.disposed(by: disposebag)
                
        //
        //        button.rx.tap // subscribe 기본적으로 background thread에서 동작 -> UI 업데이트때 에러 가능
        //            .subscribe(with: self) { owner, _ in
        //                DispatchQueue.main.async {
        //                    owner.label.text = "클릭함"
        //                }
        //            }
        //            .disposed(by: disposebag)
        //
        //        button.rx
        //            .tap
        //            .observe(on: MainScheduler.instance) // 이후 코드를 main thread에서 실행시키도록 강제
        //            .subscribe(with: self) { owner, _ in
        //                owner.label.text = "클릭함"
        //            }
        //            .disposed(by: disposebag)
        //
        //        button.rx.tap // observe, onComplete, onError까지 함축
        //            .bind(with: self) { owner, _ in
        //                owner.label.text = "클릭함"
        //            }
        //            .disposed(by: disposebag)
                
                button.rx.tap                   // observable에 이벤트를 인지시키고
                    .map { "버튼 클릭" }          // 바인딩할 observable 값을 지정하고 (스트림)
                    .bind(to: label.rx.text)   // observer에 바인딩
                    .disposed(by: disposebag)
    }
    
    func fieldHandler() {
//        textField.rx.value.orEmpty
//            .bind(to: secondLabel.rx.text)
//            .disposed(by: disposebag)
        
        button.rx.tap
            .map { self.textField.text }
            .bind(to: secondLabel.rx.text)
            .disposed(by: disposebag)
    }
}
