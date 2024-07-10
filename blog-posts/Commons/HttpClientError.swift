//
//  HttpClientError.swift
//  blog-posts
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import Foundation

enum HttpClientError: Error {
    
    case unknownError
    case requestFailed(Int)
    case decodingFailed
    
}
