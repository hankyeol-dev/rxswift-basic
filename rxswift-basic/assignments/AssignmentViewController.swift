//
//  AssignmentViewController.swift
//  rxswift-basic
//
//  Created by 강한결 on 7/30/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class AssignmentViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let resultLabel = UILabel()
    private let pickerView = UIPickerView()
    
    private let resultLabel2 = UILabel()
    private let tableView = UITableView()
    
    private let resultLabel3 = UILabel()
    private let switchButton = UISwitch()
    
    let email = UITextField()
    let password = UITextField()
    let validLabel1 = UILabel()
    let validLabel2 = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setPickerView()
        setTableView()
        setSwitch()
        setNumbers()
    }
    
    func setPickerView() {
        view.addSubview(resultLabel)
        view.addSubview(pickerView)
        resultLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        pickerView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(resultLabel.snp.bottom).offset(8)
            make.height.equalTo(80)
        }
        
        let observables = Observable.just([
            "영화", "애니메이션", "드라마", "기타"
        ])
        
        observables
            .bind(to: pickerView.rx.itemTitles) { row, element in
                return element
            }
            .disposed(by: disposeBag)
        
        pickerView.rx.modelSelected(String.self)
            .bind(with: self) { owner, values in
                owner.resultLabel.text = values.first
            }
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        view.addSubview(resultLabel2)
        view.addSubview(tableView)
        resultLabel2.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(24)
            make.height.equalTo(32)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel2.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(24)
            make.height.equalTo(180)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let observables = Observable.just([
            "1", "2", "3", "4", "5"
        ])
        
        observables
            .bind(to: tableView.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                cell.textLabel?.text = "\(element)"
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .map { "\($0) is touched" }
            .bind(to: resultLabel2.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setSwitch() {
        view.addSubview(resultLabel3)
        view.addSubview(switchButton)
        resultLabel3.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(24)
            make.height.equalTo(32)
        }
        switchButton.snp.makeConstraints { make in
            make.top.equalTo(resultLabel3.snp.bottom).offset(8)
            make.leading.equalTo(24)
            make.width.equalTo(44)
        }
        
        Observable.of(false)
            .bind(to: switchButton.rx.isOn)
            .disposed(by: disposeBag)
        
        switchButton.rx.isOn
            .map { value in value ? "on" : "off" }
            .bind(to: resultLabel3.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setNumbers() {
        [email, password, validLabel1, validLabel2].forEach {
            view.addSubview($0)
        }
        email.snp.makeConstraints { make in
            make.top.equalTo(switchButton.snp.bottom).offset(8)
            make.height.equalTo(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        validLabel1.snp.makeConstraints { make in
            make.top.equalTo(email.snp.bottom).offset(2)
            make.height.equalTo(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        password.snp.makeConstraints { make in
            make.top.equalTo(validLabel1.snp.bottom).offset(8)
            make.height.equalTo(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        validLabel2.snp.makeConstraints { make in
            make.top.equalTo(password.snp.bottom).offset(2)
            make.height.equalTo(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        [email, password].forEach {
            $0.borderStyle = .line
        }
        
        Observable
            .combineLatest(email.rx.text.orEmpty, password.rx.text.orEmpty) {
                value1, value2 in
                return "\(value1), \(value2)"
            }
            .bind(to: validLabel2.rx.text)
            .disposed(by: disposeBag)
        
        email.rx.text.orEmpty
            .map { $0.count > 4 }
            .share(replay: 1)
            .bind(to: password.rx.isEnabled, validLabel2.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
