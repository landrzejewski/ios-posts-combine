//
//  Post.swift
//  blog-posts
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import Foundation

struct Post: Identifiable {
    
    let id: Int
    let userId: Int
    let title: String
    let content: String
    let author: String
    
}
