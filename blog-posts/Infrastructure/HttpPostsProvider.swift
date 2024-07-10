//
//  HttpPostsProvider.swift
//  blog-posts
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import Foundation
import Combine

final class HttpPostsProvider: PostsProvider {

    private let httpCleint: HttpClient
    private var baseUrl: String
    
    init(baseUrl: String, httpCleint: HttpClient = HttpClient()) {
        self.baseUrl = baseUrl
        self.httpCleint = httpCleint
    }
    
    func getPosts(with query: String) -> AnyPublisher<[Post], PostsLoadingError> {
        let postDtos = getPostDtos()
            .flatMap { $0.publisher }
            .filter(titleContains(query))
            .collect()
            .eraseToAnyPublisher()
        return Publishers.CombineLatest(getUserDtos(), postDtos)
            .mapError { _ in PostsLoadingError() }
            .map { users, posts in
                posts.compactMap { post in
                    guard let user = users.first(where: { $0.id == post.userId }) else {
                        return nil
                    }
                    return Post(id: post.id, userId: user.id, title: post.title, content: post.body, author: user.username)
                }
            }
            .eraseToAnyPublisher()
    }
 
    private func titleContains(_ text: String) -> (PostDto) -> Bool {
        { post in post.title.lowercased().contains(text.lowercased()) }
    }
    
    private func getPostDtos() -> AnyPublisher<[PostDto], HttpClientError> {
        let url = URL(string: "\(baseUrl)/posts")!
        return httpCleint.get(from: url)
    }
    
    private func getUserDtos() -> AnyPublisher<[UserDto], HttpClientError> {
        let url = URL(string: "\(baseUrl)/users")!
        return httpCleint.get(from: url)
    }
    
}
