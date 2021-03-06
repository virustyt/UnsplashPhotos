//
//  Router.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 01.02.2022.
//

import Foundation

protocol RandomPhotosRouterProtocol {
    func showPhotoDetailsViewController(for photo : Photo?)
}

class RandomPhotosRouter: BaseRouter, RandomPhotosRouterProtocol {

    func showPhotoDetailsViewController(for photo : Photo?) {
        let photoDetailsViewController = PhotoDetailsViewController()

        photoDetailsViewController.router = PhotoDetailsRouter(viewController: photoDetailsViewController)
        if let detailedPhoto = photo {
            photoDetailsViewController.viewModel = PhotoDetailsViewModel(photo: detailedPhoto)
        }

        viewController?.navigationController?.pushViewController(photoDetailsViewController, animated: true)
    }
}
