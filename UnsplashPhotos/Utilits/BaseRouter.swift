//
//  BaseRouter.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 01.02.2022.
//

import Foundation

class BaseRouter {
    weak var viewController: BaseViewController?

    init(viewController: BaseViewController) {
        self.viewController = viewController
    }
}
