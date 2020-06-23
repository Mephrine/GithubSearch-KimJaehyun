//
//  UserInfo.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/22.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 # (S) UserInfo
 - Author: Mephrine
 - Date: 20.06.22
 - Note: 검색된 개인 유저 모델
*/
struct UserInfo: ALSwiftyJSONAble {
    let name: String?  // 유저 이름
    let avatarUrl: String?  // 유저 아바타 이미지 URL
    let publicRepos: Int?   // Public Repository Number
    
    init?(jsonData: JSON) {
        self.name = jsonData["name"].string
        self.avatarUrl = jsonData["avatarUrl"].string
        self.publicRepos = jsonData["public_repos"].int
    }
}
