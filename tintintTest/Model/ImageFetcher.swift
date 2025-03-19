//
//  ImageFetcher.swift
//  tintintTest
//
//  Created by Woody on 2025/3/19.
//

import RxSwift
import RxAlamofire
import UIKit


struct Image {
    let image: UIImage
    let urlStr: String
}

protocol ImageFetcher {
    func fetch(with urlStr: String) -> Observable<Image>
}

struct ImageRepostory: ImageFetcher {
    
    func fetch(with urlStr: String) -> Observable<Image> {
        if let image = cache.get(forKey: urlStr) {
            return .just(Image(image: image, urlStr: urlStr))
        }
        
        guard let url = URL(string: urlStr) else { return .error(MyError.urlInvilad) }
        return RxAlamofire.requestData(.get, url)
            .observe(on: MainScheduler.instance)
            .map(\.1)
            .map {
                guard let image = UIImage(data: $0) else {
                    throw MyError.imageError
                }
                return image
            }
            .map { return .init(image: $0, urlStr: urlStr)}
            .do(onNext: cache.save(with:))
    }
    
    private let cache = ImageCache.shared
}

fileprivate class ImageCache {
    
    static let shared = ImageCache()
    
    func save(with image: Image) {
        save(image.image, forKey: image.urlStr)
    }
    
    func save(_ image: UIImage, forKey key: String) {
        store.setObject(image, forKey: key as NSString)
    }
    
    func get(forKey key: String) -> UIImage? {
        return store.object(forKey: key as NSString)
    }
    
    private let store: NSCache<NSString, UIImage> = .init()
        
    private init() {
        store.totalCostLimit = 200 * 1024 * 1024
    }
}
