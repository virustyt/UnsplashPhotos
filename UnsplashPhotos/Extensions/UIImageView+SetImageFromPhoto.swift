//
//  UIImageView+SetImageFromPhotoWithIndex.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 03.02.2022.
//

import UIKit

extension UIImageView {
    func setImage(from photo: Photo?) {
        guard let photosUrlAdress = photo?.imageUrlAdress,
              let photosUrl = URL(string: photosUrlAdress)
        else {
            self.image = R.image.noImageFound()
            return
        }
        ImageClient.shared.setImage(on: self, from: photosUrl, with: R.image.placeholder())
    }
}
