//
//  ViewController.swift
//  tintintTest
//
//  Created by Woody on 2025/3/19.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        binding()
    }
    private let btn = UIButton()
    
    private let bag = DisposeBag()
}

extension ViewController {
    func setUI() {
        btn.setTitle("CLICL", for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 30)
        btn.backgroundColor = .lightGray
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func binding() {
        btn.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { _ in }
            .bind(to: rx.pushBinder)
            .disposed(by: bag)
    }
}

fileprivate extension Reactive where Base == ViewController {
    
    var pushBinder: Binder<Void> {
        return .init(base) { `self`, _ in
            self.navigationController?.pushViewController(PhotosViewController(), animated: true)
        }
    }
    
}
