//
//  UserInfoModel.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/3.
//

import Foundation

struct UserInfoResponse: Decodable {
    var response: [UserInfo]
}

struct UserInfo: Decodable {
    var name: String
    var kokoid: String
}
