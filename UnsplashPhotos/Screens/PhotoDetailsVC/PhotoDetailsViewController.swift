//
//  PhotoDetailsViewController.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 02.02.2022.
//

import UIKit

fileprivate extension Consts {
    static let photoImageViewTopInset: CGFloat = 30
    static let photoImageViewTrailingInset: CGFloat = 30
    static let photoImageViewLeadingInset: CGFloat = 30

    static let lablesStackImageViewTopInset: CGFloat = 30
    static let lablesStackImageViewBottomInset: CGFloat = 30
    static let lablesStackImageViewLeadingInset: CGFloat = 30
    static let lablesStackImageViewTrailingCInset: CGFloat = 30
}

class PhotoDetailsViewController: BaseViewController {

    private lazy var photosInfo = viewModel?.getPhotoInfo()

    var viewModel: PhotoDetailsViewModelProtocol?
    var router: PhotoDetailsRouterProtocol?

    private var markBarButtonItem: UIBarButtonItem?

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setImage(from: viewModel?.displpayedPhoto)
        return imageView
    }()

    private lazy var alertController: UIAlertController = {
            let alertController = UIAlertController(title: "Apply changes?",
                                                    message: nil,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes",
                                                    style: .default,
                                                    handler: self.alertControllerYesTapped(action:)))
            alertController.addAction(UIAlertAction(title: "No",
                                                    style: .default,
                                                    handler: self.alertControllerNoTapped(action:)))
            return alertController
        }()

    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 15)
        label.text = "Author:  \(photosInfo?.name ?? "no info, sorry")."
        return label
    }()

    private lazy var creationDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 15)
        label.text = " Created:  \(photosInfo?.creationDate ?? "no info, sorry")"
        return label
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 15)
        label.text = " Location:  \(photosInfo?.location ?? "no info, sorry")"
        return label
    }()
    
    private lazy var downloadsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 15)
        label.text = photosInfo?.downloadsCount == nil ? "Downloads:  no info, sorry" :  "Downloads:  \(photosInfo!.downloadsCount!)"
        return label
    }()

    private lazy var lablesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [authorNameLabel, locationLabel, creationDateLabel, downloadsLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        setUpNavigationItem()
    }

    // MARK: - private funcs
    private func setUpConstraints() {
        self.view.addSubview(photoImageView)
        self.view.addSubview(lablesStackView)

        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        lablesStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                constant: Consts.photoImageViewTopInset),
            photoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: Consts.photoImageViewLeadingInset),
            photoImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -Consts.photoImageViewTrailingInset),

            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),


            lablesStackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor,
                                                constant: Consts.lablesStackImageViewTopInset),
            lablesStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: Consts.lablesStackImageViewLeadingInset),
            lablesStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -Consts.lablesStackImageViewTrailingCInset),
            lablesStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                 constant: -Consts.lablesStackImageViewBottomInset)
        ])
    }

    private func setUpNavigationItem() {
        navigationItem.rightBarButtonItem = markBarButtonItem
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(backButtonTapped))

        guard let photoIsFavorite = viewModel?.photoMarkedAsFavourite
        else { return }
        markBarButtonItem = UIBarButtonItem(image: photoIsFavorite ? .strokedCheckmark : .add,
                                             style: .plain,
                                              target: self,
                                              action: #selector(markBarButtonItemTapped))
        self.navigationItem.rightBarButtonItem = markBarButtonItem
    }

    @objc private func backButtonTapped() {
        if viewModel?.photoHasChangesToBeSaved() != nil,
           viewModel!.photoHasChangesToBeSaved(){
            self.present(alertController, animated: true, completion: nil)
        } else {
            router?.showRandomPhotoViewController()
        }
    }

    @objc private func markBarButtonItemTapped() {
        guard let photoIsFavorite = viewModel?.photoMarkedAsFavourite
        else { return }
        markBarButtonItem?.image = photoIsFavorite ? .add : .checkmark
        viewModel?.changeFavouritePhotoStatus()
    }

    @objc private func alertControllerYesTapped(action: UIAlertAction) {
        viewModel?.saveFavouritePhotoStatus()
        router?.showRandomPhotoViewController()
    }

    @objc private func alertControllerNoTapped(action: UIAlertAction) {
        router?.showRandomPhotoViewController()
    }
}
