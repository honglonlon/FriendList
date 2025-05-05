//
//  HomeViewModel.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/3.
//

import UIKit
import Combine

class HomeViewModel {
    
    @Published var userInfo: UserInfo?
    @Published var friendList: [Friend] = []
    @Published var invitingList: [Friend] = []
    @Published var errorMessage: String? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] compeletion in
                switch compeletion {
                case .failure(let error):
                    self?.errorMessage = "取得使用者資訊失敗：\(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { [weak self] userInfo in
                self?.errorMessage = nil
                self?.userInfo = userInfo
            }
            .store(in: &cancellables)
    }
    
    func getEmptyList() {
        NetworkManager.shared.getFriendList(from: APIEndpoint.friend4.url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "取得朋友列表失敗：\(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { [weak self] friendList in
                self?.errorMessage = nil
                self?.friendList = friendList
            }
            .store(in: &cancellables)
    }
    
    
    func getFriendList() {
        let publisher1 = NetworkManager.shared.getFriendList(from: APIEndpoint.friend1.url)
        let publisher2 = NetworkManager.shared.getFriendList(from: APIEndpoint.friend2.url)
        
        Publishers.Zip(publisher1, publisher2)
            .map { list1, list2 -> [Friend] in
                var dict = [String: Friend]()
                for friend in list1 + list2 {
                    guard friend.status != .inviting else { continue }
                    if let existingFriend = dict[friend.fid],
                       existingFriend.updateDate >= friend.updateDate {
                        continue
                    }
                    dict[friend.fid] = friend
                }
                return dict.values.sorted { $0.updateDate > $1.updateDate }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "取得朋友列表失敗：\(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { [weak self] finalList in
                self?.errorMessage = nil
                self?.friendList = finalList
            }
            .store(in: &cancellables)
    }
    
    
    func getFriendListWithInviting() {
        NetworkManager.shared.getFriendList(from: APIEndpoint.friend3.url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "取得朋友列表失敗：\(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { [weak self] friendList in
                self?.errorMessage = nil
                
                self?.invitingList = friendList
                    .filter { $0.status == .inviting }
                    .sorted { $0.updateDate > $1.updateDate }   
                
                self?.friendList = friendList
                    .filter { $0.status != .inviting }
                    .sorted { $0.updateDate > $1.updateDate }
            }
            .store(in: &cancellables)
    }
    
    
    
    
}
