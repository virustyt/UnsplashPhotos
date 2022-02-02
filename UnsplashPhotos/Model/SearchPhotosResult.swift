//
//  SearchPhotosResult.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 02.02.2022.
//

import Foundation

struct SearchPhotosResult: Codable {
    let results: [Photo]?

    enum CodingKeys: String, CodingKey {
        case results
    }
}
