//
//  MainServiceStub.swift
//  GithubSearchTests
//
//  Created by Mephrine on 2020/06/23.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import RxSwift
@testable import GithubSearch

struct MainServiceStub: MainServiceProtocol {    
    func fetchSearchUser(searchText: String, _ sort: SearchSort = .match , _ order: SearchOrder = .desc, _ page: Int = 1) -> Single<SearchUser> {
        return Single<SearchUser>.create { observer in
            if let dummy = SearchUserDummy.jsonData {
                observer(.success(dummy))
            } else {
                observer(.error(APIError.noData))
            }
            return Disposables.create()
        }
    }
    
    func fetchUserInfo(userName: String) -> Single<UserInfo> {
        return Single<UserInfo>.create { observer in
            if let dummy = UserInfoDummy.jsonData {
                observer(.success(dummy))
            } else {
                observer(.error(APIError.noData))
            }
            return Disposables.create()
        }
    }
}
