//
//  NetworkManager.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/3.
//

import Foundation
import Combine

protocol NetworkService {
    func getUserInfo() -> AnyPublisher<UserInfo, Error>
    func getFriendList(from url: URL?) -> AnyPublisher<[Friend], Error>
}

class NetworkManager: NetworkService {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func getUserInfo() -> AnyPublisher<UserInfo, Error> {
        guard let url = APIEndpoint.user.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return urlSession.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: UserInfoResponse.self, decoder: JSONDecoder())
            .tryMap({ res in
                guard let userInfo = res.response.first else {
                    throw URLError(.cannotParseResponse)
                }
                return userInfo
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func getFriendList(from url: URL?) -> AnyPublisher<[Friend], Error> {
        
        guard let url = url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return urlSession.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: FriendListResponse.self, decoder: JSONDecoder())
            .map { $0.response }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
}
