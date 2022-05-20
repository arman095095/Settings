//
//  AccountService.swift
//  
//
//  Created by Арман Чархчян on 10.04.2022.
//

import Foundation
import FirebaseFirestore
import ModelInterfaces
import UIKit
import NetworkServices

protocol AccountNetworkServiceProtocol {
    func setOffline(accountID: String)
    func removeAccount(accountID: String,
                       completion: @escaping (Error?) -> Void)
    func unblockUser(accountID: String,
                     userID: String, complition: @escaping (Result<Void,Error>) -> Void)
    func getBlockedIds(accountID: String,
                       completion: @escaping (Result<[String],Error>) -> Void)
    
}

final class AccountNetworkService {
    
    private let networkServiceRef: Firestore

    private var usersRef: CollectionReference {
        return networkServiceRef.collection(URLComponents.Paths.users.rawValue)
    }
    
    init(networkService: Firestore) {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        networkService.settings = settings
        self.networkServiceRef = networkService
    }
}

extension AccountNetworkService: AccountNetworkServiceProtocol {
    
    public func getBlockedIds(accountID: String, completion: @escaping (Result<[String], Error>) -> Void) {
        var ids: [String] = []
        usersRef.document(accountID).collection(URLComponents.Paths.blocked.rawValue).getDocuments { (query, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let query = query else { return }
            query.documents.forEach { doc in
                if let id = doc.data()[URLComponents.Parameters.id.rawValue] as? String {
                    ids.append(id)
                }
            }
            completion(.success(ids))
        }
    }
    
    public func setOffline(accountID: String) {
        var dict: [String: Any] = [URLComponents.Parameters.lastActivity.rawValue: FieldValue.serverTimestamp()]
        dict[URLComponents.Parameters.online.rawValue] = false
        usersRef.document(accountID).updateData(dict) { _ in }
    }
    
    public func removeAccount(accountID: String, completion: @escaping (Error?) -> Void) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            completion(ConnectionError.noInternet)
            return
        }
        usersRef.document(accountID).updateData([URLComponents.Parameters.removed.rawValue: true]) { (error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    public func unblockUser(accountID: String,
                            userID: String,
                            complition: @escaping (Result<Void,Error>) -> Void) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            complition(.failure(ConnectionError.noInternet))
            return
        }
        usersRef.document(accountID).collection(URLComponents.Paths.blocked.rawValue).document(userID).delete { error in
            if let error = error {
                complition(.failure(error))
                return
            }
            complition(.success(()))
        }
    }
}
