//
//  PhotoCell.swift
//  tintintTest
//
//  Created by Woody on 2025/3/19.
//

import UIKit
import RxSwift

final class PhotoCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func configure(with viewModel: CellViewModel) {
        self.viewModel = viewModel
        self.bag = DisposeBag()
        self.binding()
    }
    
    func willDisplay() {
        viewModel?.fetch()
    }
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .label
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    
    private var bag = DisposeBag()
    
    private var viewModel: CellViewModel?
}

fileprivate extension PhotoCell {
    
    func setUI() {
        [imageView, idLabel, titleLabel].forEach(contentView.addSubview(_:))
        
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        idLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(13)
            make.top.equalToSuperview().offset(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(6)
            make.bottom.equalToSuperview().offset(-5)
        }
        
    }
    
    func binding() {
        let output = viewModel?.transform()
        output?.id
            .bind(to: idLabel.rx.text)
            .disposed(by: bag)
        output?.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: bag)
        output?.image
            .map(\.image)
            .bind(to: imageView.rx.image)
            .disposed(by: bag)
    }
    
}
