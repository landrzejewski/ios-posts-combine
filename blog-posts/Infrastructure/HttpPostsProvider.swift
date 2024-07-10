//
//  HttpPostsProvider.swift
//  blog-posts
//
//  Created by Łukasz Andrzejewski on 10/07/2024.
//

import Foundation
import Combine

final class HttpPostsProvider: PostsProvider {

    private var baseUrl: String
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(baseUrl: String, session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.baseUrl = baseUrl
        self.session = session
        self.decoder = decoder
    }
    
    func getPosts(with query: String) async throws -> [Post] {
        do {
            async let postDtos: [PostDto] = get(url: URL(string: "\(baseUrl)/posts")!)
            async let userDtos: [UserDto] = get(url: URL(string: "\(baseUrl)/users")!)
            let posts = try await postDtos
            let users = try await userDtos
            return posts.compactMap { post in
                guard let user = users.first(where: { $0.id == post.userId }) else {
                    return nil
                }
                return Post(id: post.id, userId: user.id, title: post.title, content: post.body, author: user.username)
            }
        } catch {
            throw PostsLoadingError()
        }
    }
 
    private func titleContains(_ text: String) -> (PostDto) -> Bool {
        { post in post.title.lowercased().contains(text.lowercased()) }
    }
    
    private func get<Model: Decodable>(url: URL) async throws -> [Model] {
        let (data, _) = try await session.data(from: url)
        return try decoder.decode([Model].self, from: data)
    }

    
}
