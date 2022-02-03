//
//  PhotosNetClient.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 01.02.2022.
//

import Foundation

protocol PhotoNetClientProtocol {
    func getRandomPhotos(complition: @escaping ([RawPhoto]?, Error?) -> ()) -> URLSessionDataTask?
    func getPhotosBy(query: String, complition: @escaping ([RawPhoto]?, Error?) -> ()) -> URLSessionDataTask?
}

class PhotoNetClient: PhotoNetClientProtocol {
    private enum RequestError: Error{
        case noBaseURLExistsForSpaceXObject(object:RawPhoto)
    }

    private enum RequestType {
        case random, query
    }

    private let baseUrls: URL
    private let urlSession: URLSession
    private var resopnseQueue: DispatchQueue? = nil
    private let token = "8Yfo8Hd4K71AIAtcQALPua-gEnW5R8tCpVOoPaJkRCk"

    static let shared = PhotoNetClient(baseUrls: URL(string: "https://api.unsplash.com/")!,
                                       urlSession: URLSession.shared,
                                       responseQueue: .main)

    // MARK: - inits
    init(baseUrls: URL, urlSession: URLSession = URLSession.shared, responseQueue: DispatchQueue?){
        self.baseUrls = baseUrls
        self.urlSession = urlSession
        self.resopnseQueue = responseQueue
    }

    // MARK: - public funcs
    func getRandomPhotos(complition: @escaping ([RawPhoto]?, Error?) -> ()) -> URLSessionDataTask? {
        getPhotos(by: .random, complition: complition, request: "/photos/random?count=1")
    }

    func getPhotosBy(query: String, complition: @escaping ([RawPhoto]?, Error?) -> ()) -> URLSessionDataTask? {
        getPhotos(by: .query, complition: complition, request: "/search/photos?page=1&query=\(query)&per_page=1")
    }

    // MARK: - private funcs
    private func getPhotos(by requestType: RequestType,  complition: @escaping ([RawPhoto]?, Error?) -> (), request: String) -> URLSessionDataTask?  {
        guard let url = URL(string: request, relativeTo: baseUrls) else { return nil}

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")

        let dataTask = urlSession.dataTask(with: request) {[weak self] data, response, error in
            guard let self = self else {return}
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode,
                  let recievedData = data
            else {
                print((response as! HTTPURLResponse).statusCode)
                self.dispatchResults(error: error, complitionHandler: complition )
                return
            }
            do {
                let photos: [RawPhoto]?
                switch requestType{
                case .query:
                    let searchPhotosResult = try JSONDecoder().decode(SearchedRawPhotos.self, from: recievedData)
                    photos = searchPhotosResult.results
                case .random:
                    photos = try JSONDecoder().decode([RawPhoto].self, from: recievedData)
                }
                self.dispatchResults(model: photos, complitionHandler: complition)
            } catch {
                self.dispatchResults(error: error, complitionHandler: complition)
            }
        }
        dataTask.resume()
        return dataTask
    }

    func dispatchResults<Type>(model: Type? = nil, error: Error? = nil, complitionHandler: @escaping (Type?,Error?) -> ()){
        guard let responseQueue = self.resopnseQueue
        else {
            complitionHandler(model,error)
            return
        }
        responseQueue.async { complitionHandler(model,error) }
    }
}
