//
//  PostDto.swift
//  blog-posts
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import Foundation

struct PostDto: Decodable {
    
    let id: Int
    let userId: Int
    let title: String
    let body: String
    
}
