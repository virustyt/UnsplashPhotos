//
//  PhotoDetailsRouter.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 02.02.2022.
//

import Foundation

protocol PhotoDetailsRouterProtocol {
    func showRandomPhotoViewController()
}

class PhotoDetailsRouter: BaseRouter, PhotoDetailsRouterProtocol {
    func showRandomPhotoViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
