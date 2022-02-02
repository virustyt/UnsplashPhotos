//
//  PhotoManager.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 01.02.2022.
//

import UIKit

protocol PhotoManagerProtocol {
    func getPhotosCount() -> Int
    func getPhotoImageUrlBy(index: Int) -> URL?
    func getPhotosInfoBy(index: Int) -> PhotosInfo?
    func refreshPhotos(complition: (() -> ())?)
    func getPhotosBy(query: String, complition: (() -> ())?)
}

class PhotoManager: PhotoManagerProtocol {
    private(set) var photos = [Photo]()

    private let imageNetClient: ImageClientProtocol = ImageClient.shared
    private let photosNetClient: PhotoNetClientProtocol = PhotoNetClient.shared

    private var dataTasks = [DataTasksType: URLSessionDataTask]()
    private enum DataTasksType {
        case getRandomPhotos, getPhotosByQuery
    }

    static let shared = PhotoManager()

    // MARK: - public funcs
    func getPhotosCount() -> Int {
        photos.count
    }

    func getPhotoImageUrlBy(index: Int) -> URL? {
        if index > photos.count - 1 {
            return nil
        }
        guard let imageUrl = photos[index].urls?.regular
        else { return nil }
        return URL(string: imageUrl)
    }

    func getPhotosInfoBy(index: Int) -> PhotosInfo? {
        if index > photos.count - 1 {
            return nil
        }
        let photosInfo = photos[index]
        let creationDate = getCreationDate(from: photosInfo.createdAt ?? "")
        return PhotosInfo(name: photosInfo.user?.name,
                          creationDate: creationDate,
                          location: photosInfo.location?.name,
                          downloadsCount: photosInfo.downloads)
    }

    func refreshPhotos(complition: (() -> ())?) {
        guard dataTasks[.getRandomPhotos] == nil else { return }
        dataTasks
            .forEach{
                if ($0.key != .getRandomPhotos)
                {
                    dataTasks.removeValue(forKey: $0.key)
                }
            }
        dataTasks[.getRandomPhotos] = photosNetClient.getRandomPhotos { [weak self] recievedPhotos, error in
            guard let photos = recievedPhotos else { return }
            self?.photos = photos
            self?.dataTasks[.getRandomPhotos] = nil
            
            guard let coplitionClouser = complition
            else { return }
            coplitionClouser()
        }
    }

    func getPhotosBy(query: String, complition: (() -> ())?) {
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

    // MARK: - private funcs
    private func getCreationDate(from stringDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        guard let date = dateFormatter.date(from: stringDate) else { return "" }
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd, yyyy")
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }

}
