//
//  FavoritePhotosViewController.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 01.02.2022.
//

import UIKit

fileprivate extension Consts {
    static let tableViewTopInset: CGFloat = 10
    static let tableViewLeadingInset: CGFloat = 0
    static let tableViewTrailingInset: CGFloat = 0
    static let tableViewBottomInset: CGFloat = 0

    static let tableViewCellIdentifier = "cell"

    static let tableViewCellHeight: CGFloat = 120
}

class FavoritePhotosViewController: BaseViewController {

    var viewModel: FavouritePhotosViewModelProtocol?
    var router: FavouritePhotosRouterProtocol?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Consts.tableViewCellIdentifier)
        return tableView
    }()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - private funcs
    private func setUpConstraints() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Consts.tableViewCellHeight
    }
}

// MARK: - UITableViewDataSource
extension FavoritePhotosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.photosCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Consts.tableViewCellIdentifier, for: indexPath)
        cell.imageView?.setImageFromPhoto(withIndex: indexPath.item, from: .favoriteList)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.textLabel?.text = viewModel?.getPhotoBy(index: indexPath.item)?.name ?? "the author is unknown"
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritePhotosViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhoto = viewModel?.getPhotoBy(index: indexPath.item)
        router?.showPhotoDetailsViewController(for: selectedPhoto)
    }
}


