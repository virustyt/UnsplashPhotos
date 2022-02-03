//
//  ViewModel.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 01.02.2022.
//

import UIKit

protocol RandomPhotoViewModelProtocol {
    func photosCount() -> Int
    func setNewPhotosByRandom(complition: (() -> ())?)
    func setNewPhotosBy(query: String, complition: (() -> ())?)
    func getPhotoBy(index: Int) -> Photo?
}

class RandomPhotosViewModel: RandomPhotoViewModelProtocol {

    private let manager: PhotoManagerProtocol = PhotoManager.shared

    func setNewPhotosByRandom(complition: (() -> ())?) {
        manager.setNewPhotosByRandom(complition: complition)
    }

    func setNewPhotosBy(query: String, complition: (() -> ())?) {
        manager.setNewPhotosBy(query: query, complition: complition)
    }

    func getPhotoBy(index: Int) -> Photo? {
        manager.getRandomPhotoBy(index: index)
    }

    func photosCount() -> Int {
        manager.photos.count
    }
}
