//
//  MainVM.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/22.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import ReactorKit


enum APIError: Error {
    case errorURL
    case noData
    case network
    
    var desc: String? {
        switch self {
        case .errorURL:
            return "Error : Incorrect URL"
        case .noData:
            return "Error : NoData"
        case .network:
            return "Error : Network"
        }
    }
}

/**
 # (C) MainVM
 - Author: Mephrine
 - Date: 20.06.22
 - Note: 메인화면 ViewModel
 */
final class MainVM: BaseVM, Reactor {
    var initialState = State()
    
    typealias Services = HasMainService
    var services: Services
    
    init(withService service: AppServices) {
        self.services = service
    }
    
    /**
     # (E) Action
     - Author: Mephrine
     - Date: 20.06.22
     - Note: ReactorKit에서 ViewController에서 실행될 Action을 모아둔 enum
     */
    enum Action {
        case inputUserName(userName: String)        // 텍스트 입력
        case pullRefreshControl                     // 20개 더 불러오기
    }
    
    /**
     # (E) Mutation
     - Author: Mephrine
     - Date: 20.06.22
     - Note: ReactorKit에서 Action이 들어오면 비즈니스 로직 처리 후 변경 값을 리턴하는 로직을 담당하는 Mutation함수에서 처리할 enum 모음
     */
    enum Mutation {
        case searchUser(userList: [UserInfo]?)
        case addPageList(userList: [UserInfo]?)
    }
    
    /**
     # (S) State
     - Author: Mephrine
     - Date: 20.06.22
     - Note: ReactorKit에서 상태값을 관리하는 구조체
     */
    struct State {
        var page: Int = 1
        var userList: [UserInfo]? // 유저 이름만 뽑아낸 리스트
        var searchUserName: String?
    }
    
    /**
     # mutate
     - Author: Mephrine
     - Date: 20.06.22
     - Parameters:
     - action: 실행된 action
     - Returns: Observable<Mutation>
     - Note: Action이 들어오면 해당 부분을 타고, Service와의 Side Effect 처리를 함. (API 통신 등.) 그리고 Mutaion으로 반환
     */
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .inputUserName(let userName):
            return services.mainService.rx.searchUser(searchText: userName, .match, .desc, 1)
                .map { $0.items }
                .asObservable()
                .filterNil()
                .flatMap{
                    Observable.combineLatest($0.map { [unowned self] item in
                        self.services.mainService.rx
                            .userInfo(userName: item.login!)
                            .asObservable()
                    })
            }
            .catchErrorJustReturn([])
            .map{ Mutation.searchUser(userList: $0) }
        case .pullRefreshControl:
            return services.mainService.rx.searchUser(searchText: currentState.searchUserName ?? "", .match, .desc, currentState.page)
                .map { $0.items }
                .asObservable()
                .filterNil()
                .flatMap{
                    Observable.combineLatest($0.map { [unowned self] item in
                        self.services.mainService.rx
                            .userInfo(userName: item.login!)
                            .asObservable()
                    })
            }
            .catchErrorJustReturn([])
            .map{ Mutation.searchUser(userList: $0) }
        }
        
    }
    /**
     # reduce
     - Author: Mephrine
     - Date: 20.06.22
     - Parameters:
     - state: 이전 state
     - mutation: 변경된 mutation
     - Returns: Bool
     - Note: 이전의 상태값과 Mutation을 이용해서 새로운 상태값을 반환
     */
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .searchUser(let userList):
            newState.page = 2
            newState.userList = userList
            break
        case .addPageList(let userList):
            newState.page += 1
            if let addUserList = userList {
                newState.userList?.append(contentsOf: addUserList)
            }
        }
        return newState
    }
}
