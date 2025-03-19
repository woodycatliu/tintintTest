//
//  Photo.swift
//  tintintTest
//
//  Created by Woody on 2025/3/19.
//

struct Assets: Codable {
    let id: Int
    let title: String
    let thumbnailUrl: String
}

struct Photo: Decodable {
    let id: Int
    let title: String
    let thumbnailUrl: String
    
    init(_ assets: Assets) {
        let urlStr = assets.thumbnailUrl.replacingOccurrences(of: "via.placeholder.com", with: "placehold.co") + "/999.png"
        self.init(id: assets.id, title: assets.title, thumbnailUrl: urlStr)
    }
    
    init(id: Int, title: String, thumbnailUrl: String) {
        self.id = id
        self.title = title
        self.thumbnailUrl = thumbnailUrl
    }
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case thumbnailUrl
    }
    
    init(from decoder: any Decoder) throws {
        let assets = try Assets.init(from: decoder)
        self.init(assets)
    }
    
}
