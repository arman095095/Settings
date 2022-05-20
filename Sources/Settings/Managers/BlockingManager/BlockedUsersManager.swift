//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import NetworkServices
import Services
import ModelInterfaces

public enum BlockingManagerError: LocalizedError {
    case cantUnblock
    
    public var errorDescription: String? {
        switch self {
        case .cantUnblock:
            return "Не удалось разблокировать пользователя"
        }
    }
}

public protocol BlockedUsersManagerProtocol {
    func blockedProfiles(completion: @escaping (Result<[ProfileModelProtocol], Error>) -> Void)
    func unblockProfile(_ id: String,
                        completion: @escaping (Result<Void, BlockingManagerError>) -> Void)
}

final class BlockedUsersManager {
    private let accountID: String
    private let accountService: AccountNetworkServiceProtocol
    private let account: AccountModelProtocol
    private let cacheService: AccountCacheServiceProtocol
    private let profileService: ProfilesNetworkServiceProtocol
    
    init(account: AccountModelProtocol,
         accountID: String,
         accountService: AccountNetworkServiceProtocol,
         profileService: ProfilesNetworkServiceProtocol,
         cacheService: AccountCacheServiceProtocol) {
        self.account = account
        self.accountID = accountID
        self.accountService = accountService
        self.profileService = profileService
        self.cacheService = cacheService
    }
}

extension BlockedUsersManager: BlockedUsersManagerProtocol {
    public func blockedProfiles(completion: @escaping (Result<[ProfileModelProtocol], Error>) -> Void) {
        accountService.getBlockedIds(accountID: accountID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ids):
                self.account.blockedIds = Set(ids)
                self.cacheService.store(accountModel: self.account)
                let group = DispatchGroup()
                var profiles = [ProfileModelProtocol]()
                ids.forEach {
                    group.enter()
                    self.profileService.getProfileInfo(userID: $0) { result in
                        defer { group.leave() }
                        switch result {
                        case .success(let profile):
                            profiles.append(ProfileModel(profile: profile))
                        case .failure:
                            break
                        }
                    }
                }
                group.notify(queue: .main) {
                    completion(.success(profiles))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func unblockProfile(_ id: String,
                               completion: @escaping (Result<Void, BlockingManagerError>) -> Void) {
        accountService.unblockUser(accountID: accountID,
                                   userID: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                guard let firstIndex = self.account.blockedIds.firstIndex(of: id) else { return }
                self.account.blockedIds.remove(at: firstIndex)
                self.cacheService.store(accountModel: self.account)
                completion(.success(()))
            case .failure:
                completion(.failure(.cantUnblock))
            }
        }
    }
}
