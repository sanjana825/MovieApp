//
//  MovieService.swift
//  MovieApp
//
//  Created by Sanjana on 15/09/24.
//

import Foundation

class MovieService{
    
    // MARK: - Properties
    static let shared = MovieService()
    
    // MARK: - Initializer
    private init() {}
    
    // MARK: - Method
    public func request<T: Decodable>(urlRequest: URLRequest, resultType: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void){
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode(T.self, from: data!)
                    DispatchQueue.main.async {
                        completionHandler(.success(result))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
}





