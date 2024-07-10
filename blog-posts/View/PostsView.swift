//
//  PostsView.swift
//  blog-posts
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import SwiftUI

struct PostsView: View {
    
    @StateObject var viewModel: PostsViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .initial:
                    infoView(iconName: "doc.text.magnifyingglass", message: "Enter a title above to find matching posts")
                case .loading:
                    ProgressView()
                case .loaded(let data):
                    if data.isEmpty {
                        infoView(iconName: "folder.badge.questionmark", message: "No results found. Try a different title")
                    } else {
                        postsListView(data)
                    }
                case .error(_):
                    infoView(iconName: "exclamationmark.warninglight", message: "Opps! Something went wrong. Try again.")
                }
            }
            .searchable(text: $viewModel.query, prompt: "Search for posts by title")
        }
    }
    
    private func infoView(iconName: String, message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 64))
            Text(message)
                .font(.title3)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
    }
    
    private func postsListView(_ posts: [Post]) -> some View {
        List(posts) { post in
            VStack(alignment: .leading) {
                Text(post.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(post.content)
                    .font(.caption)
                    .lineLimit(3)
                    .padding(.top, 6)
                HStack {
                    Spacer()
                    Text(post.author)
                        .font(.footnote)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
    
}

#Preview {
    PostsView(viewModel: PostsViewModel(postsProvider: HttpPostsProvider(baseUrl: "https://jsonplaceholder.typicode.com")))
}
