//
//  MainService.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/22.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

/**
 # (P) HasMainService
 - Author: Mephrine
 - Date: 20.06.22
 - Note: 메인 검색 관련 서비스 프로토콜을 사용하기 위한 변수를 선언한 프로토콜
*/
protocol HasMainService {
    var mainService: MainService { get }
}

public enum SearchSort {
    case match
    case star
    case fork
    case issue
    case updated
    
    var value: String {
        switch self {
        case .match:
            return ""
        case .star:
            return "stars"
        case .fork:
            return "forks"
        case .issue:
            return "help-wanted-issues"
        case .updated:
            return "updated"
        }
    }
}

public enum SearchOrder {
    case desc
    case asc
    
    var value: String {
        switch self {
        case .asc:
            return "asc"
        default:
            return "desc"
        }
    }
}

/**
 # (C) MainService
 - Author: Mephrine
 - Date: 20.06.22
 - Note: 메인 검색 API 관련 서비스 클래스.
*/
class MainService {
    private let networking = MNetworking()
    // 1번만 실행.
    private let updateSubject = ReplaySubject<User?>.create(bufferSize: 1)
    
    /**
     # searchUser
     - Author: Mephrine
     - Date: 20.06.22
     - Parameters:
     - Returns: Single<AppVersion>
     - Note: 네트워크 통신을 통해 유저 검색 정보를 받아옴.
    */
//    fileprivate func fetchSearchUser(_ searchText: String, _ sort: SearchSort, _ order: SearchOrder, _ page: Int) -> Single<User> {
//        return networking.request(.searchUser(q: searchText, sort: sort.value, order: order.value, page: page))
//            .map(to: User.self)
//    }
    
    /**
     # searchUser
     - Author: Mephrine
     - Date: 20.06.22
     - Parameters:
     - Returns: Single<AppVersion>
     - Note: 네트워크 통신을 통해 유저 검색 정보를 받아옴.
    */
    fileprivate func fetchUserInfo(userName: String) -> Single<UserInfo> {
        return networking.request(.getUserInfo(userName: userName))
            .map(to: UserInfo.self)
    }
    
}

extension MainService: ReactiveCompatible {}

extension Reactive where Base: MainService {
    /**
     # searchUser
     - Author: Mephrine
     - Date: 20.06.22
     - Parameters:
     - Returns: Observable<User>
     - Note: 유저 검색 정보를 rx로 접근 가능하도록 확장한 함수.
    */
//    func searchUser(searchText: String, sort: SearchSort, order: SearchOrder, page: Int) -> Observable<User> {
//        return base.searchUser(searchText, sort, order, page).asObservable()
//    }
}



