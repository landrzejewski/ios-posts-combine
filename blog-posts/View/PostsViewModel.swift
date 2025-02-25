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
            .sink { self.getPosts(with: $0) }
            .store(in: &subscriptions)
    }
    
    private func getPosts(with query: String) {
        state = .loading
        postsProvider.getPosts(with: query)
            .sink { complition in
                if case .failure(let error) = complition {
                    self.state = .error(error)
                }
            } receiveValue: { posts in
                self.state = .loaded(posts)
            }
            .store(in: &subscriptions)
    }
    
}
