//
//  CellViewModel.swift
//  tintintTest
//
//  Created by Woody on 2025/3/19.
//

import RxSwift
import RxCocoa
import Foundation

final class CellViewModel: ReactiveCompatible {
    
    struct Input {}
    
    struct Output {
        let id: Observable<String>
        let title: Observable<String>
        let image: Observable<Image>
    }
    
    init(photo: Photo, fetcher: ImageFetcher = ImageRepostory()) {
        self.photo = .init(value: photo)
        self.fetcher = fetcher
    }
    
    func fetch() {
        excute.accept(())
    }
    
    func transform(input: Input? = nil) -> Output {
        let image = excute
            .flatMapLatest(photo.asObservable)
            .flatMap(rx.fetchImage)
        return .init(
            id: photo.map(\.id).map(String.init),
            title: photo.map(\.title),
            image: image
        )
    }
    
    fileprivate let fetcher: ImageFetcher
    
    fileprivate let excute = PublishRelay<Void>()
    
    fileprivate let photo: BehaviorRelay<Photo>
}

extension Reactive where Base == CellViewModel {
    
    func fetchImage(_ photo: Photo) -> Observable<Image> {
        base.fetcher.fetch(with: photo.thumbnailUrl)
            .retry(1)
            .materialize()
            .map(\.element)
            .compactMap { $0 }
    }
    
}
