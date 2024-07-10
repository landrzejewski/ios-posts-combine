//
//  BlogPostsApp.swift
//  blog-posts
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import SwiftUI

@main
struct BlogPostsApp: App {
    
    let postsProvider = HttpPostsProvider(baseUrl: "https://jsonplaceholder.typicode.com")
    
    var body: some Scene {
        WindowGroup {
            PostsView(viewModel: PostsViewModel(postsProvider: postsProvider))
        }
    }
    
}
