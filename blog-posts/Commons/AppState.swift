//
//  State.swift
//  blog-posts
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import Foundation

enum AppState<Data> {
    
    case initial, loading, loaded(Data), error(Error)
    
}
