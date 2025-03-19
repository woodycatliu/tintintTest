//
//  PhotosViewController.swift
//  tintintTest
//
//  Created by Woody on 2025/3/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class PhotosViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        binding()
    }
    
    private let viewModel = PhotosViewModel()
    
    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: CVLayout())
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.description())
        return cv
    }()
    
    private let bag = DisposeBag()
}

fileprivate extension PhotosViewController {
    
    func setUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    func binding() {
        let output = viewModel.transform(input: .init(viewWillAppear: rx.viewWillAppear))

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CellViewModel>> {_, collectionView, indexPath, viewModel in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.description(), for: indexPath)
            (cell as? PhotoCell)?.configure(with: viewModel)
            return cell
        }
        
        output.photos
            .map(\.cellViewModels)
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        collectionView.rx.willDisplayCell
            .map(\.cell)
            .bind(to: rx.willDisplayBinder)
            .disposed(by: bag)
    }
}

fileprivate extension Array where Element == Photo {
    var cellViewModels: [CellViewModel] {
        self.map { photo in
            CellViewModel.init(photo: photo)
        }
    }
}

fileprivate extension Reactive where Base == PhotosViewController {
    
    var willDisplayBinder: Binder<UICollectionViewCell> {
        return .init(base) { _, cell in
            (cell as? PhotoCell)?.willDisplay()
        }
    }
}



func CVLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalWidth(0.25))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let subitems = [item, item, item, item]
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.25))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: subitems)
    group.interItemSpacing = .fixed(3)
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    section.interGroupSpacing = 2
    
    let layout = UICollectionViewCompositionalLayout(section: section)
    
    return layout
}


fileprivate extension Reactive where Base: UIViewController {
    
    var viewWillAppear: Observable<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source).asObservable()
    }
}
