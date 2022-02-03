//
//  UIImageView+SetImage.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 02.02.2022.
//

import UIKit

enum PhotoListType {
    case randomList, favoriteList
}

extension UIImageView {
    func setImageFromPhoto(withIndex photoIndex: Int, from photoListType: PhotoListType) {
        var photosUrlAdress: String? = nil
        switch photoListType {
        case .favoriteList:
            if photoIndex >= PhotoManager.shared.photos.count - 1 {
                photosUrlAdress = PhotoManager.shared.favouritePhotos[photoIndex].imageUrlAdress
            }
        case .randomList:
            if photoIndex >= PhotoManager.shared.photos.count - 1 {
                photosUrlAdress = PhotoManager.shared.photos[photoIndex].urls?.regular
            }
        }
        guard let photosUrl = photosUrlAdress,
            let urlAdress = URL(string: photosUrl)
        else {
            self.image = R.image.noImageFound()
            return
        }
        ImageClient.shared.setImage(on: self, from: urlAdress, with: R.image.placeholder())
    }
}
