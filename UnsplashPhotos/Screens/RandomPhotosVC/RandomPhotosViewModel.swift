//
//  ViewModel.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 01.02.2022.
//

import UIKit

protocol RandomPhotoViewModelProtocol {
    func setImage(on imageView: UIImageView, by photoIndex: Int, with imagePlacholder: UIImage?)
    func photosCount() -> Int
    func getNewPhotos(complition: (() -> ())?)
    func getPhotosBy(query: String, complition: (() -> ())?)
}

class RandomPhotosViewModel: RandomPhotoViewModelProtocol {
    private let imageClient: ImageClientProtocol = ImageClient.shared
    private let manager: PhotoManagerProtocol = PhotoManager.shared

    private var dataTask: URLSessionDataTask?

    func setImage(on imageView: UIImageView, by photoIndex: Int, with imagePlacholder: UIImage?) {
        if let photoImageUrl = manager.getPhotoImageUrlBy(index: photoIndex) {
            imageClient.setImage(on: imageView, from: photoImageUrl, with: imagePlacholder, complition: nil)
        }
    }

    func photosCount() -> Int {
        manager.getPhotosCount()
    }

    func getNewPhotos(complition: (() -> ())?) {
        manager.refreshPhotos(complition: complition)
    }

    func getPhotosBy(query: String, complition: (() -> ())?) {
        manager.getPhotosBy(query: query, complition: complition)
    }
}
