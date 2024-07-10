//
//  HttpClient.swift
//  blog-posts
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import Foundation
import Combine

final class HttpClient {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get<Model: Decodable>(from url: URL, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Model, HttpClientError> {
        session.dataTaskPublisher(for: url)
            .mapError { _ in HttpClientError.unknownError }
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw HttpClientError.unknownError
                }
                if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                    throw HttpClientError.requestFailed(httpResponse.statusCode)
                }
                return data
            }
            .decode(type: Model.self, decoder: decoder)
            .mapError { _ in HttpClientError.decodingFailed }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
