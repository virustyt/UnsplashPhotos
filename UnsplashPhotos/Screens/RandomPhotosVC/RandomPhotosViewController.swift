//
//  RandomPhotosViewController.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 01.02.2022.
//

import UIKit

fileprivate extension Consts {

    static let searchTextFieldTopInset: CGFloat = 10
    static let searchTextFieldLeadingInset: CGFloat = 30
    static let searchTextFieldTrailingInset: CGFloat = 30

    static let collectionViewdTopInset: CGFloat = 10
    static let collectionViewLeadingInset: CGFloat = 0
    static let collectionViewTrailingInset: CGFloat = 0
    static let collectionViewBottomInset: CGFloat = 0

    static let collectionViewMinLineSpacing: CGFloat = 30
    static let collectionViewMinInteritemSpacing: CGFloat = 30
}

class RandomPhotosViewController: BaseViewController {

    var viewModel: RandomPhotoViewModelProtocol?
    var router: RandomPhotosRouterProtocol?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifyer)
        return collectionView
    }()

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = R.font.montserratSemiBold(size: 28)
        textField.backgroundColor = .white
        textField.delegate = self
        textField.returnKeyType = .search

        let placeholderTextAttributes: [NSAttributedString.Key: Any] = [.font: R.font.montserratSemiBold(size: 28) ??
                                                                            UIFont.systemFont(ofSize: 28),
                                                                        .foregroundColor: UIColor.black]
        textField.attributedPlaceholder = NSAttributedString(string: "search...",
                                                             attributes: placeholderTextAttributes)
        return textField
    }()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRefreshControl()
        setUpConstraints()
        refreshData()
    }

    // MARK: - private funcs
    @objc private func refreshData(){
        viewModel?
            .setNewPhotosByRandom{ [weak self] in
                self?.collectionView.reloadData()
                self?.collectionView.refreshControl?.endRefreshing()
            }
    }

    private func setUpRefreshControl(){
        let control = UIRefreshControl()
        collectionView.refreshControl = control

        control.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        control.attributedTitle = NSAttributedString(string: "Loading...")
    }

    private func setUpConstraints() {
        view.addSubview(collectionView)
        view.addSubview(searchTextField)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: Consts.searchTextFieldTopInset),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                     constant: Consts.searchTextFieldLeadingInset),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                      constant: -Consts.searchTextFieldTrailingInset),

            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor,
                                                constant: Consts.collectionViewdTopInset),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                    constant: Consts.collectionViewLeadingInset),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -Consts.collectionViewTrailingInset),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -Consts.collectionViewBottomInset)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension RandomPhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.photosCount() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifyer,
                                     for: indexPath) as? PhotoCollectionViewCell
        else { return UICollectionViewCell() }
        cell.photoImageView.setImageFromPhoto(withIndex: indexPath.item, from: .randomList)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RandomPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = viewModel?.getPhotoBy(index: indexPath.item)
        router?.showPhotoDetailsViewController(for: selectedPhoto)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let smallestSideOfViewSize = view.frame.width >= view.frame.height ? view.frame.height : view.frame.width

        let itemSize = CGSize(width: smallestSideOfViewSize - Consts.collectionViewMinLineSpacing * 2,
                              height: (smallestSideOfViewSize - Consts.collectionViewMinInteritemSpacing * 2) * 0.9)
        return itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Consts.collectionViewMinLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Consts.collectionViewMinLineSpacing - Consts.searchTextFieldTopInset,
                            left: 0,
                            bottom: 0,
                            right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Consts.collectionViewMinInteritemSpacing
    }
}

// MARK: - UITextFieldDelegate
extension RandomPhotosViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewModel?.setNewPhotosBy(query: textField.text ?? "") { [weak self] in
            self?.collectionView.reloadData()
        }
        return true
    }
}
