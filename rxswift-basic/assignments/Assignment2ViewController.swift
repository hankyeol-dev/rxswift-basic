//
//  Assignment2ViewController.swift
//  rxswift-basic
//
//  Created by 강한결 on 7/31/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class Assignment2ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let segement = UISegmentedControl(items: ["number", "validation", "table"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(segement)
        
        segement.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        segement.addTarget(self, action: #selector(segmentControl), for: .valueChanged)
    }
    
    @objc
    private func segmentControl(_ component: UISegmentedControl) {
        cleanSubViews()
        switch component.selectedSegmentIndex {
        case 0:
            showNumbers()
        case 1:
            showValidation()
        case 2:
            showTable()
        default:
            break
        }
    }
    
    private func showNumbers() {
        let number1 = UITextField()
        let number2 = UITextField()
        let number3 = UITextField()
        let resultlabel = UILabel()
        
        [number1, number2, number3].forEach {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
                make.height.equalTo(44)
            }
            $0.borderStyle = .roundedRect
            $0.keyboardType = .numberPad
            $0.textAlignment = .center
        }
        view.addSubview(resultlabel)
        
        number1.snp.makeConstraints { make in
            make.top.equalTo(segement.snp.bottom).offset(12)
        }
        number2.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(12)
        }
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(12)
        }
        resultlabel.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(12)
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        resultlabel.textAlignment = .center
        
        Observable.combineLatest(
            number1.rx.text.orEmpty,
            number2.rx.text.orEmpty,
            number3.rx.text.orEmpty
        ) { value1, value2, value3 -> Int in
            return (Int(value1) ?? 0) + (Int(value2) ?? 0) + (Int(value3) ?? 0)
        }
        .map { String($0) }
        .bind(to: resultlabel.rx.text)
        .disposed(by: disposeBag)
    }
    
    private func showValidation() {
        let nickField = UITextField()
        let nickValidLabel = UILabel()
        let password = UITextField()
        let passwordValidLabel = UILabel()
        let button = UIButton()
        let components = [nickField, nickValidLabel, password, passwordValidLabel, button]
        
        components.enumerated().forEach { idx, element in
            view.addSubview(element)
            element.snp.makeConstraints { make in
                make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
                make.height.equalTo(44)
            }
            if idx == 0 {
                element.snp.makeConstraints { make in
                    make.top.equalTo(segement.snp.bottom).offset(12)
                }
            } else {
                element.snp.makeConstraints { make in
                    make.top.equalTo(components[idx - 1].snp.bottom).offset(12)
                }
            }
        }
        
        [nickField, password].forEach {
            $0.borderStyle = .roundedRect
        }
        button.backgroundColor = .blue
        
        let nickValidText = BehaviorSubject(value: "닉네임은 5자 이상이어야 함")
        let passwordValidText = PublishSubject<String>()
        
        nickValidText
            .bind(to: nickValidLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        let nicknameValidation = nickField.rx.text.orEmpty
            .map { $0.count > 4 }
        
        let passwordValidation = password.rx.text.orEmpty
            .map { $0.count > 4 }
    
        nicknameValidation
            .subscribe(with: self) { owner, value in
                if value {
                    nickValidText.onNext("닉네임 검증 성공")
                    passwordValidText.onNext("비밀번호도 5자 이상이어야 함")
                    passwordValidText.bind(to: passwordValidLabel.rx.text)
                        .disposed(by: owner.disposeBag)
                } else {
                    nickValidText.onNext("닉네임은 5자 이상이어야 함")
                    passwordValidText.onNext("")
                }
            }
            .disposed(by: disposeBag)
        
        nicknameValidation
            .bind(to: password.rx.isEnabled)
            .disposed(by: disposeBag)
        
        passwordValidation
            .subscribe(with: self) { owner, value in
                if value {
                    passwordValidText.onNext("비밀번호 검증 성공")
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            nicknameValidation,
            passwordValidation
        ) { $0 && $1 }
        .bind(to: button.rx.isEnabled)
        .disposed(by: disposeBag)
        
        button.rx.tap
            .subscribe { _ in
                print("성공~ 야호~")
            }
            .disposed(by: disposeBag)
    }
    
    private func showTable() {
        let table = UITableView()
        
        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.top.equalTo(segement.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let tableItems = BehaviorSubject(value: (0..<20).map { "\($0)" })
        
        tableItems
            .bind(to: table.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = "\(element) in \(row)"
            }
            .disposed(by: disposeBag)
        
        table.rx.modelSelected(String.self)
            .subscribe { value in
                print(value)
            }
            .disposed(by: disposeBag)
        
    }
    
    
    private func cleanSubViews() {
        if view.subviews.count != 0 {
            view.subviews.enumerated().forEach { idx, child in
                if idx > 0 {
                    child.removeFromSuperview()
                }
            }
        }
    }
}
