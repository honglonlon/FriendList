//
//  APIEndpoint.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/4.
//

import Foundation

private let baseURL = "https://dimanyen.github.io/"

enum APIEndpoint: String {
    case user       = "man.json"
    case friend1    = "friend1.json"
    case friend2    = "friend2.json"
    case friend3    = "friend3.json"
    case friend4    = "friend4.json"

    var url: URL? {
        URL(string: baseURL + self.rawValue)
    }
}
