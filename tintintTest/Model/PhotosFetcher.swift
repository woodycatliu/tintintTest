//
//  PhotosFetcher.swift
//  tintintTest
//
//  Created by Woody on 2025/3/19.
//

import RxSwift
import RxAlamofire

protocol PhotosFetcher {
    func fetch() -> Observable<[Photo]>
}

struct PhotosProvider: PhotosFetcher {
    func fetch() -> Observable<[Photo]> {
        return RxAlamofire
            .requestDecodable(.get, url)
            .map(\.1)
    }
    let url = URL(string: "https://jsonplaceholder.typicode.com/photos")!
}
