//
//  SearchPhotosResult.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 02.02.2022.
//

import Foundation

struct SearchedRawPhotos: Codable {
    let results: [RawPhoto]?

    enum CodingKeys: String, CodingKey {
        case results
    }
}
