//
//  FavouritePhotosViewModel.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 02.02.2022.
//

import Foundation

protocol FavouritePhotosViewModelProtocol {
    func photosCount() -> Int
    func getPhotoBy(index: Int) -> Photo?
}

class FavouritePhotosViewModel: FavouritePhotosViewModelProtocol {

    private let manager: PhotoManagerProtocol = PhotoManager.shared

    func photosCount() -> Int {
        manager.favouritePhotos.count
    }

    func getPhotoBy(index: Int) -> Photo? {
        manager.getFavouritePhotoBy(index: index)
    }
}
