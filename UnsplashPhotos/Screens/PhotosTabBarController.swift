//
//  PhotosTabBarController.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 01.02.2022.
//

import UIKit

class PhotosTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setUpViewControllers()
    }

    private func setUpViewControllers() {
        let favoritePhotosViewController = FavoritePhotosViewController()
        favoritePhotosViewController.viewModel = FavouritePhotosViewModel()
        favoritePhotosViewController.router = FavouritePhotosRouter(viewController: favoritePhotosViewController)

        let favoritePhotosNavController = createNavControllerWithTabBarItem(for: favoritePhotosViewController,
                                                                            withTitle: "favorite",
                                                                            AndImage: R.image.favoritePhotos())

        let randomPhotosViewController = RandomPhotosViewController()
        randomPhotosViewController.viewModel = RandomPhotosViewModel()
        randomPhotosViewController.router = RandomPhotosRouter(viewController: randomPhotosViewController)

        let randomPhotosNavController = createNavControllerWithTabBarItem(for: randomPhotosViewController,
                                                                          withTitle: "photos",
                                                                          AndImage: R.image.randomPhotos())

        self.setViewControllers([randomPhotosNavController,favoritePhotosNavController], animated: false)
    }

    private func createNavControllerWithTabBarItem(for viewController: UIViewController, withTitle title: String, AndImage image: UIImage?) -> UINavigationController{
        let navController = UINavigationController(rootViewController: viewController)

        navController.tabBarItem.title = title
        navController.tabBarItem.image = image

        navController.view.backgroundColor = .cyan

        return navController
    }
}
