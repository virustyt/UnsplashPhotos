//
//  FavouritePhotosRouter.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 02.02.2022.
//

import Foundation

protocol FavouritePhotosRouterProtocol {
    func showPhotoDetailsViewController(for photo : Photo?)
}

class FavouritePhotosRouter: BaseRouter, FavouritePhotosRouterProtocol {
    func showPhotoDetailsViewController(for photo : Photo?) {
        let photoDetailsViewController = PhotoDetailsViewController()

        photoDetailsViewController.router = PhotoDetailsRouter(viewController: photoDetailsViewController)
        if let detailedPhoto = photo {
            photoDetailsViewController.viewModel = PhotoDetailsViewModel(photo: detailedPhoto)
        }

        viewController?.navigationController?.pushViewController(photoDetailsViewController, animated: true)
    }
}
