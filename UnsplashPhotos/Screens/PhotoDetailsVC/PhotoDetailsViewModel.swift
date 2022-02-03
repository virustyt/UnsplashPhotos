//
//  PhotoDetailsViewModel.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 02.02.2022.
//

import Foundation

protocol PhotoDetailsViewModelProtocol {
    var photoMarkedAsFavourite: Bool { get }
    var displpayedPhoto: Photo { get }

    func getPhotoInfo() -> Photo
    func changeFavouritePhotoStatus()
    func saveFavouritePhotoStatus()
    func photoHasChangesToBeSaved() -> Bool
}

class PhotoDetailsViewModel: PhotoDetailsViewModelProtocol {

    private let imageClient: ImageClientProtocol = ImageClient.shared
    private let manager: PhotoManagerProtocol = PhotoManager.shared

    private var thereIsChangesToBeSaved: Bool = false
    private(set) lazy var photoMarkedAsFavourite: Bool = {
        if  manager.favouritePhotos.contains(where: { $0.id == displpayedPhoto.id }) {
            return true
        } else {
            return false
        }
    }() {
        didSet {
            thereIsChangesToBeSaved = true
        }
    }

    private(set) var displpayedPhoto: Photo

    // MARK: - public funcs
    func getPhotoInfo() -> Photo {
        displpayedPhoto
    }

    func changeFavouritePhotoStatus() {
        photoMarkedAsFavourite.toggle()
    }

    func saveFavouritePhotoStatus() {
        if photoMarkedAsFavourite == true,
           !manager.favouritePhotos.contains(where: { $0.id == displpayedPhoto.id }) {
            manager.addToFavourite(photo: displpayedPhoto)
        }
        else if photoMarkedAsFavourite == false,
                manager.favouritePhotos.contains(where: { $0.id == displpayedPhoto.id }) {
            manager.removeFromFavourite(photo: displpayedPhoto)
        }
    }

    func photoHasChangesToBeSaved() -> Bool {
        return thereIsChangesToBeSaved
    }

    // MARK: - inits
    init(photo: Photo) {
        displpayedPhoto = photo
    }
}
