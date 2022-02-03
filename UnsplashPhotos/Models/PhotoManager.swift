//
//  PhotoManager.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 01.02.2022.
//

import UIKit

protocol PhotoManagerProtocol {
    var photos: [RawPhoto] {get}
    var favouritePhotos: [Photo] {get}

    func setNewPhotosByRandom(complition: (() -> ())?)
    func setNewPhotosBy(query: String, complition: (() -> ())?)

    func getRandomPhotoBy(index: Int) -> Photo?
    func getFavouritePhotoBy(index: Int) -> Photo?

    func addToFavourite(photo: Photo)
    func removeFromFavourite(photo: Photo)
}

class PhotoManager: PhotoManagerProtocol {

    private(set) var photos = [RawPhoto]()
    private(set) var favouritePhotos = [Photo]()

    private let imageNetClient: ImageClientProtocol = ImageClient.shared
    private let photosNetClient: PhotoNetClientProtocol = PhotoNetClient.shared

    private var dataTasks = [DataTasksType: URLSessionDataTask]()
    private enum DataTasksType {
        case getRandomPhotos, getPhotosByQuery
    }

    static let shared = PhotoManager()

    // MARK: - public funcs
    func getRandomPhotoBy(index: Int) -> Photo? {
        if index > photos.count - 1 {
            return nil
        }
        let photosInfo = photos[index]
        let creationDate = getCreationDate(from: photosInfo.createdAt ?? "")

        return Photo(id: photosInfo.id,
                     imageUrlAdress: photosInfo.urls?.regular,
                     name: photosInfo.user?.name,
                     creationDate: creationDate,
                     location: photosInfo.location?.name,
                     downloadsCount: photosInfo.downloads)
    }

    func getFavouritePhotoBy(index: Int) -> Photo? {
        if index > favouritePhotos.count - 1 {
            return nil
        }
        return favouritePhotos[index]
    }

    func setNewPhotosByRandom(complition: (() -> ())?) {
        guard dataTasks[.getRandomPhotos] == nil else { return }
        dataTasks
            .forEach{
                if ($0.key != .getRandomPhotos)
                {
                    dataTasks.removeValue(forKey: $0.key)
                }
            }
        dataTasks[.getRandomPhotos] = photosNetClient.getRandomPhotos { [weak self] recievedPhotos, error in
            // here
            guard let photos = recievedPhotos else {
                return
            }
            self?.photos = photos
            self?.dataTasks[.getRandomPhotos] = nil
            
            guard let coplitionClouser = complition
            else { return }
            coplitionClouser()
        }
    }

    func setNewPhotosBy(query: String, complition: (() -> ())?) {
        guard dataTasks[.getPhotosByQuery] == nil else { return }
        dataTasks
            .forEach{
                if ($0.key != .getPhotosByQuery)
                {
                    dataTasks.removeValue(forKey: $0.key)
                }
            }
        dataTasks[.getPhotosByQuery] = photosNetClient.getPhotosBy(query: query) { [weak self] recievedPhotos, error in
            guard let photos = recievedPhotos else { return }
            self?.photos = photos
            self?.dataTasks[.getPhotosByQuery] = nil

            guard let coplitionClouser = complition
            else { return }
            coplitionClouser()
        }
    }

    func addToFavourite(photo: Photo) {
        if !favouritePhotos.contains(where: { photo.id == $0.id }) {
            favouritePhotos.append(photo)
        }
    }

    func removeFromFavourite(photo: Photo) {
        favouritePhotos.removeAll(where: { $0.id == photo.id })
    }

    // MARK: - private funcs
    private func getCreationDate(from stringDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        guard let date = dateFormatter.date(from: stringDate) else { return "" }
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd, yyyy")
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }

}
