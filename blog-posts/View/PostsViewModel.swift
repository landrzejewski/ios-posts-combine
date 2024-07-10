//
//  PostsViewModel.swift
//  blog-posts
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import Foundation
import Combine

final class PostsViewModel: ObservableObject {
    
    @Published var query: String = ""
    @Published var state: AppState<[Post]> = .initial
    
    private let postsProvider: PostsProvider
    private var subscriptions: Set<AnyCancellable> = []
    
    init(postsProvider: PostsProvider) {
        self.postsProvider = postsProvider
        bind()
    }
    
    private func bind() {
        $query
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .removeDuplicates()
            .sink { query in
                Task {
                    await self.getPosts(with: query)
                }
            }
            .store(in: &subscriptions)
    }
     
    @MainActor
    private func getPosts(with query: String) async {
        state = .loading
        do {
            let posts = try await postsProvider.getPosts(with: query)
            state = .loaded(posts)
        } catch {
            state = .error(error)
        }
    }
    
}
