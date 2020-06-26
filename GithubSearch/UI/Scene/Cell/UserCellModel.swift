//
//  UserCellModel.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/23.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation

struct UserCellModel {
    let model: UserInfo
    
    var imageURL: URL? {
        guard let strURL = model.avatarUrl else { return nil }
        return URL(string: strURL)
    }
    
    var userLoginID: String {
        return self.model.login ?? ""
    }
    
    var publicRepo: String {
        return "Number of repos: \(self.model.publicRepos ?? 0)"
    }
    
    init(model: UserInfo) {
        self.model = model
    }
}
