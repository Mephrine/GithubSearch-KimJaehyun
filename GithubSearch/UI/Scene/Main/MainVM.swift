//
//  MainVM.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/22.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import ReactorKit


/**
# (E) APIError
- Author: Mephrine
- Date: 20.06.22
- Note: API Error 모음
*/
enum APIError: Error {
    case noData
    
    var desc: String? {
        switch self {
        case .noData:
            return "Error : NoData"
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
    
    // Service
    typealias Services = HasMainService
    var services: Services
    
    // e.g.
    var isLoading = PublishSubject<Bool>()         // 로딩바 관리
    var isSearchReload = PublishSubject<Bool>()    // 검색어 변경으로 인한 리로드
    
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
        case loadMore                               // 20개 더 불러오기
    }
    
    /**
     # (E) Mutation
     - Author: Mephrine
     - Date: 20.06.22
     - Note: ReactorKit에서 Action이 들어오면 비즈니스 로직 처리 후 변경 값을 리턴하는 로직을 담당하는 Mutation함수에서 처리할 enum 모음
     */
    enum Mutation {
        case searchUser(userList: [MainTableViewSection])
        case searchText(text: String)
        case getTotalPage(totalPage: Int)
        case addUserList(userList: [MainTableViewSection])
    }
    
    /**
     # (S) State
     - Author: Mephrine
     - Date: 20.06.22
     - Note: ReactorKit에서 상태값을 관리하는 구조체
     */
    struct State {
        var page: Int = 1
        var totalPage: Int = 20
        var userList: [MainTableViewSection] = [] // 유저 이름만 뽑아낸 리스트
        var searchUserName: String = ""
        var noDataText: String = ""
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
            let nameObservable = Observable.of(Mutation.searchText(text: userName))
            if userName.isEmpty {
                return nameObservable
            }
            
            let requestList = services.mainService.rx
                .searchUser(searchText: userName, .match, .desc, 1)
                .share(replay: 1, scope: .forever)
            
            let pageCntObservable = requestList.map { $0.totalCount }
                .filterNil()
                .map { Mutation.getTotalPage(totalPage: $0) }
                
            let requestObservable = requestList
                .map { $0.items }
                .asObservable()
                .filterNil()
                .catchErrorJustReturn([])
                .map{ $0.map { [weak self] in UserCellModel(model: $0, service: self?.services as! AppServices)} }
                .map{ [MainTableViewSection(items: $0)] }
                .map{ Mutation.searchUser(userList: $0) }
            
            return .concat(nameObservable, requestObservable, pageCntObservable)
        case .loadMore:
            self.isLoading.onNext(true)
            return services.mainService.rx.searchUser(searchText: currentState.searchUserName , .match, .desc, currentState.page)
                            .map { $0.items }
                            .asObservable()
                            .filterNil()
                            .observeOn(Schedulers.default)
                            .catchErrorJustReturn([])
                                .map{ $0.map { [weak self] in UserCellModel(model: $0, service: self?.services as! AppServices)}
                            }
                            .map{ [MainTableViewSection(items: $0)] }
                            .map{ Mutation.addUserList(userList: $0) }
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
            if userList.isEmpty || (userList.first?.items.isEmpty ?? true) {
                newState.noDataText = STR_SEARCH_NO_DATA
            } else {
                newState.noDataText = ""
            }
            self.isSearchReload.onNext(true)
            break
        case .searchText(let text):
            newState.searchUserName = text
            if text.isEmpty {
                newState.noDataText = STR_SEARCH_NO_INPUT
                newState.userList = []
            } else {
                newState.noDataText = ""
            }
            break
        case .addUserList(let userList):
            self.isLoading.onNext(false)
            newState.page += 1
            newState.userList.append(contentsOf: userList)
        case .getTotalPage(let totalPage):
            newState.totalPage = totalPage
        }
        return newState
    }
    
    //MARK: -e.g.
    /**
     # chkEnablePaging
     - Author: Mephrine
     - Date: 20.06.27
     - Parameters:
     - Returns: Bool
     - Note: 페이징이 가능한 지에 대한 여부 반환
    */
    func chkEnablePaging() -> Bool {
        if (currentState.page - 1) * PAGE_COUNT < currentState.totalPage {
            return true
        }
        return false
    }
    
    /**
     # isEmptyCurrentUserList
     - Author: Mephrine
     - Date: 20.06.27
     - Parameters:
     - Returns: Bool
     - Note: 현재 UserList가 비어있는 지에 대해 반환
    */
    func isEmptyCurrentUserList() -> Bool {
        if currentState.userList.isEmpty || (currentState.userList.first?.items.isEmpty ?? true) {
            return true
        }
        return false
    }
}
