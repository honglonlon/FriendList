//
//  HomeViewModel.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/3.
//

import UIKit
import Combine

enum FriendListMode: String {
    case noFriend           = "無好友"
    case onlyFriend         = "只有好友"
    case friendWithInvite   = "有好友含邀請"
}

class HomeViewModel {
    //MARK: Input
    struct Input {
        let loadUserInfo: AnyPublisher<Void, Never>
        let loadFriendList: AnyPublisher<Void, Never>
        let modeChange: AnyPublisher<FriendListMode, Never>
    }
    
    //MARK: Output
    struct Output {
        let userInfo: AnyPublisher<UserInfo?, Never>
        let friendList: AnyPublisher<[Friend], Never>
        let invitingList: AnyPublisher<[Friend], Never>
        let errorMessage: AnyPublisher<String?, Never>
        let friendListMode: AnyPublisher<FriendListMode, Never>
    }
    
    
    //MARK: Properties
    @Published private(set) var userInfo: UserInfo?
    @Published private(set) var friendList: [Friend] = []
    @Published private(set) var invitingList: [Friend] = []
    @Published private(set) var errorMessage: String? = nil
    @Published private(set) var friendListMode: FriendListMode = .noFriend
    private var cancellables = Set<AnyCancellable>()
    
    
    //MARK: Transform
    func transform(input: Input) -> Output {
        input.modeChange
            .sink { [weak self] mode in
                self?.friendListMode = mode
                switch mode {
                case .noFriend:
                    self?.getEmptyList()
                case .onlyFriend:
                    self?.getFriendList()
                case .friendWithInvite:
                    self?.getFriendListWithInviting()
                }
            }
            .store(in: &cancellables)
        
        input.loadFriendList
            .sink {[weak self] _ in
                self?.getEmptyList()
            }
            .store(in: &cancellables)
        
        input.loadUserInfo
            .sink { [weak self] _ in
                self?.getUserInfo()
            }
            .store(in: &cancellables)
        
        return Output(
            userInfo: $userInfo.eraseToAnyPublisher(),
            friendList: $friendList.eraseToAnyPublisher(),
            invitingList: $invitingList.eraseToAnyPublisher(),
            errorMessage: $errorMessage.eraseToAnyPublisher(),
            friendListMode: $friendListMode.eraseToAnyPublisher()
        )
    }
    
    
    //MARK: Private function
    private func getUserInfo() {
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
    
    private func getEmptyList() {
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
    
    private func getFriendList() {
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
    
    private func getFriendListWithInviting() {
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
