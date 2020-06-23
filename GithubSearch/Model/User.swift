//
//  User.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/23.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation

/**
 # (S) User
 - Author: Mephrine
 - Date: 20.06.23
 - Note: 리스트에 보여질 모델
*/
struct User {
    let login: String?
    let avatarUrl: String?
    let type: String?
    let publicRepos: Int?
    
    init(login: String?, avatarUrl: String?, type: String?, publicRepos: Int?) {
        self.login = login
        self.avatarUrl = avatarUrl
        self.type = type
        self.publicRepos = publicRepos
    }
}
