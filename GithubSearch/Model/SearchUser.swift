//
//  SearchUser.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/23.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 # (S) SearchUser
 - Author: Mephrine
 - Date: 20.06.23
 - Note: 검색된 유저 리스트 모델
*/
struct SearchUser: ALSwiftyJSONAble {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [SearchUserItem]?
    
    init?(jsonData: JSON) {
        self.totalCount = jsonData["total_count"].int
        self.incompleteResults = jsonData["incomplete_results"].bool ?? true
        self.items = jsonData["items"].to(type: SearchUserItem.self) as? [SearchUserItem]
    }
}

/**
 # (S) SearchUserItem
 - Author: Mephrine
 - Date: 20.06.23
 - Note: 검색된 유저 리스트 아이템 모델
*/
struct SearchUserItem: ALSwiftyJSONAble {
    let login: String?      // 유저명
    let type: String?       // Organization / User
    
    init?(jsonData: JSON) {
        self.login = jsonData["login"].string
        self.type = jsonData["type"].string
    }
}
