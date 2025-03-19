//
//  PhotosViewModel.swift
//  tintintTest
//
//  Created by Woody on 2025/3/19.
//

import RxSwift
import Foundation

final class PhotosViewModel: ReactiveCompatible {
    
    init(fetcher: PhotosFetcher = PhotosProvider()) {
        self.fetcher = fetcher
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let photos: Observable<[Photo]>
    }
    
    func transform(input: Input) -> Output {
        let photos = input.viewWillAppear
            .flatMap(rx.fetchPhotos)
        return .init(photos: photos)
    }
 
    fileprivate let fetcher: PhotosFetcher
}

extension Reactive where Base == PhotosViewModel {
    
    func fetchPhotos() -> Observable<[Photo]> {
        return base.fetcher.fetch()
            .retry(2)
            .materialize()
            .compactMap(\.element)
    }
}
