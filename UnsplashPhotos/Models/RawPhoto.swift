//
//  Photo.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 01.02.2022.
//

import Foundation

struct RawPhoto: Codable {
    let id: String?
    let urls: Urls?
    let user: User?
    let createdAt: String?
    let location: Location?
    let downloads: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case urls
        case user
        case createdAt = "created_at"
        case location
        case downloads
    }
}

// MARK: - Location
struct Location: Codable {
    let name, city, country: String?
    let position: Position?
}

// MARK: - Position
struct Position: Codable {
    let latitude, longitude: Double?
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String?
    let thumb: String?
}

// MARK: - User
struct User: Codable {
    let id: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}




