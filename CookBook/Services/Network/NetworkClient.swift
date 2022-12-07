//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 16.11.2022.
//

import UIKit

enum ServiceError: Error {
    case network(statusCode: Int)
    case parsing
    case general(reason: String)
}

class NetworkClient {
    
    var pagination = false
    
    func getImageWith(router: ImageRouter, completion: @escaping (UIImage) -> Void) {
        guard let stringUrl = router.stringUrl else { return }
        
        if let image = ImageCache.shared.take(with: stringUrl) {
            completion(image)
            return
        }
        
        guard let url = URL(string: stringUrl) else { return }
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                print("Error with download image from url - \(stringUrl)")
            }
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            
            ImageCache.shared.put(image: image, with: stringUrl)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
    
    func request<T: Decodable>(router: NetworkRouter, completion: @escaping (Result<T, Error>) -> ()) {
        pagination = true
        var urlComponents = URLComponents()
        urlComponents.scheme = router.scheme
        urlComponents.host = router.host
        urlComponents.path = router.path
        urlComponents.queryItems = router.queryItems
        
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error with create request: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            guard let data = data else { return }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
                self.pagination = false
            } catch {
                print("Error with decoded data from network: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

enum ImageRouter {
    case imageRequest(imageName: String, imageType: ImageType)
    case imageUrlRequest(stringUrl: String)
    
    var stringUrl: String? {
        switch self {
        case .imageRequest:
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = host
            urlComponents.path = path
            urlComponents.queryItems = queryItems
            return urlComponents.url?.absoluteString
        case .imageUrlRequest(let stringUrl):
            return stringUrl
        }
    }
    
    var scheme: String {
        switch self {
        case .imageRequest:
            return "https"
        case .imageUrlRequest:
            return ""
        }
    }
    
    var host: String {
        switch self {
        case .imageRequest:
            return "spoonacular.com"
        case .imageUrlRequest:
            return ""
        }
    }
    
    var path: String {
        switch self {
        case .imageRequest(let imageName, let imageType):
            switch imageType {
            case .equipment, .ingredient:
                return "/cdn/\(imageType.type)\(imageType.size)/\(imageName)"
            }
        case .imageUrlRequest:
            return ""
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .imageRequest, .imageUrlRequest:
            return []
        }
    }
    
    enum ImageType {
        case ingredient(withSize: ImageSize)
        case equipment(withSize: ImageSize)
        
        enum ImageSize {
            case small
            case medium
            case large
        }
        
        var type: String {
            switch self {
            case .ingredient:
                return "ingredients_"
            case .equipment:
                return "equipment_"
            }
        }
        
        var size: String {
            switch self {
            case .ingredient(let withSize), .equipment(let withSize):
                switch withSize {
                case .small:
                    return "100x100"
                case .medium:
                    return "250x250"
                case .large:
                    return "500x500"
                }
            }
        }
    }
}

enum NetworkRouter {
    case randomRequest(tags: [String])
    case searchRequest(text: String, number: String, offset: String)
    
    var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
        }
        return value
    }
    
    var scheme: String {
        switch self {
        case .randomRequest, .searchRequest:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case .randomRequest, .searchRequest:
            return "api.spoonacular.com"
        }
    }
    
    var path: String {
        switch self {
        case .randomRequest:
            return "/recipes/random"
        case .searchRequest:
            return "/recipes/complexSearch"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .randomRequest(let tags):
            return [URLQueryItem(name: "apiKey", value: apiKey),
                    URLQueryItem(name: "number", value: String(10)),
                    URLQueryItem(name: "tags", value: tags.joined(separator: ","))]
        case .searchRequest(let text, let number, let offset):
            return [URLQueryItem(name: "apiKey", value: apiKey),
                    URLQueryItem(name: "number", value: number),
                    URLQueryItem(name: "addRecipeNutrition", value: String(true)),
                    URLQueryItem(name: "addRecipeInformation", value: String(true)),
                    URLQueryItem(name: "number", value: number),
                    URLQueryItem(name: "sort", value: "popularity"),
                    URLQueryItem(name: "query", value: text),
                    URLQueryItem(name: "offset", value: offset)]
        }
    }
}
