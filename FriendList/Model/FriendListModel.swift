//
//  FriendListModel.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/3.
//

import Foundation

struct FriendListResponse : Codable {
    let response: [Friend]
}

struct Friend: Codable {
    let name: String
    let status: FriendStatus
    let isTop: String
    let fid: String
    let updateDate: String
}

enum FriendStatus: Int, Codable {
    case inviteSent = 0   // 邀請送出
    case completed  = 1   // 已完成
    case inviting   = 2   // 邀請中
}


