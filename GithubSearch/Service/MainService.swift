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
 # (P) MainServiceProtocol
 - Author: Mephrine
 - Date: 20.06.22
 - Note: 메인화면 ViewModel에서 구현 필요
*/
protocol MainServiceProtocol {
    func fetchSearchUser(searchText: String, _ sort: SearchSort, _ order: SearchOrder, _ page: Int) -> Single<SearchUser>
    func fetchUserInfo(userName: String) -> Single<UserInfo>
}


/**
 # (C) MainService
 - Author: Mephrine
 - Date: 20.06.22
 - Note: 메인 검색 API 관련 서비스 클래스.
*/
class MainService {
    private let networking = MNetworking()
    
    /**
     # searchUser
     - Author: Mephrine
     - Date: 20.06.22
     - Parameters:
         - searchText : 텍스트필드에 입력된 텍스트
         - sort : 정렬 기준
         - order : 오름차순 / 내림차순
         - page : 불러올 페이지 수
     - Returns: Single<AppVersion>
     - Note: 네트워크 통신을 통해 유저 검색 정보를 받아옴.
    */
    fileprivate func fetchSearchUser(searchText: String, _ sort: SearchSort, _ order: SearchOrder, _ page: Int) -> Single<SearchUser> {
        // 기존에 검색하던 조건 캔슬하고 새로운 텍스트로 다시 검색하기
        networking.session.cancelAllRequests()
        return networking.request(.searchUser(q: searchText, sort: sort.value, order: order.value, page: page))
            .map(to: SearchUser.self)
    }
    
    /**
     # searchUser
     - Author: Mephrine
     - Date: 20.06.22
     - Parameters:
        - userName : 검색할 유저명
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
        - searchText : 텍스트필드에 입력된 텍스트
        - sort : 정렬 기준
        - order : 오름차순 / 내림차순
        - page : 불러올 페이지 수
     - Returns: Observable<User>
     - Note: 유저 검색 정보를 rx로 접근 가능하도록 확장한 함수.
    */
    func searchUser(searchText: String, _ sort: SearchSort, _ order: SearchOrder, _ page: Int) -> Observable<SearchUser> {
        return base.fetchSearchUser(searchText: searchText, sort, order, page).asObservable()
    }
    
    /**
     # searchUser
     - Author: Mephrine
     - Date: 20.06.22
     - Parameters:
        - userName : 검색할 유저명
     - Returns: Observable<User>
     - Note: 유저 검색 정보를 rx로 접근 가능하도록 확장한 함수.
    */
    func userInfo(userName: String) -> Observable<UserInfo> {
        return base.fetchUserInfo(userName: userName).asObservable()
    }
}



