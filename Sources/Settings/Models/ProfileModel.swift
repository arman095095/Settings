//
//  ProfileModel.swift
//  
//
//  Created by Арман Чархчян on 16.04.2022.
//

import Foundation
import NetworkServices
import ModelInterfaces
import Services

struct ProfileModel: ProfileModelProtocol {
    var userName: String
    var info: String
    var sex: String
    var imageUrl: String
    var id: String
    var country: String
    var city: String
    var birthday: String
    var removed: Bool
    var online: Bool
    var lastActivity: Date?
    var postsCount: Int
    
    init(profile: ProfileNetworkModelProtocol) {
        self.userName = profile.userName
        self.info = profile.info
        self.sex = profile.sex
        self.imageUrl = profile.imageUrl
        self.id = profile.id
        self.country = profile.country
        self.city = profile.city
        self.birthday = profile.birthday
        self.removed = profile.removed
        self.online = profile.online
        self.lastActivity = profile.lastActivity
        self.postsCount = profile.postsCount
    }
    
    init?(profile: Profile) {
        guard let userName = profile.userName,
              let info = profile.info,
              let sex = profile.sex,
              let imageUrl = profile.imageUrl,
              let id = profile.id,
              let country = profile.country,
              let city = profile.city,
              let birthday = profile.birthday,
              let lastActivity = profile.lastActivity else { return nil }
        
        self.userName = userName
        self.info = info
        self.sex = sex
        self.imageUrl = imageUrl
        self.id = id
        self.country = country
        self.city = city
        self.birthday = birthday
        self.removed = profile.removed
        self.online = profile.online
        self.lastActivity = lastActivity
        self.postsCount = Int(profile.postsCount)
    }
}
