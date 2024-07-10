//
//  UserDto.swift
//  blog-posts
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import Foundation

struct UserDto: Decodable {
    
    let id: Int
    let name: String
    let username: String
    let email: String
    
}
