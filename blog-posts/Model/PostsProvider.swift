//
//  PostsProvider.swift
//  blog-posts
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import Foundation
import Combine

protocol PostsProvider {
    
    func getPosts(with query: String) async throws -> [Post]
    
}
