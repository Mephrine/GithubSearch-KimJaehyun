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
    }
    
    /**
     # (E) Mutation
     - Author: Mephrine
     - Date: 20.06.22
     - Note: ReactorKit에서 Action이 들어오면 비즈니스 로직 처리 후 변경 값을 리턴하는 로직을 담당하는 Mutation함수에서 처리할 enum 모음
     */
    enum Mutation {
    }
    
    /**
     # (S) State
     - Author: Mephrine
     - Date: 20.06.22
     - Note: ReactorKit에서 상태값을 관리하는 구조체
     */
    struct State {
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
            default:
            break
        }
    }
    
    // 2. 각각의 스트림을 변형함. 다른 옵저버블 스트림을 변환, 결합 가능. (transform이 있으면 해당 부분은 transform -> reduce)
    // 전역 변수를 mutate로 변환하고 기존 Mutation하고 merge.
    //        func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    //            let stateMutation = self.services.userService.loginState
    //                .flatMap { [weak self] in
    //                    self?.mutate(loginState: $0) ?? .empty()
    //                }
    //            return Observable.of(mutation, stateMutation).merge()
    //        }
    
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
        default:
            break
        }
        return newState
    }
}
