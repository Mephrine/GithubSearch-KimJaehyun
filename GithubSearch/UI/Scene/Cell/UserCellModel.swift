//
//  UserCellModel.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/23.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import RxSwift

/**
# (C) UserCellModel
- Author: Mephrine
- Date: 20.06.23
- Note: 유저 정보를 보여주는 Cell의 Model
*/
class UserCellModel {
    let model: SearchUserItem
    let disposeBag = DisposeBag()
    
    var imageURL: URL? {
        guard let strURL = model.avatarUrl else { return nil }
        return URL(string: strURL)
    }
    
    var userLoginID: String {
        return self.model.login ?? ""
    }

    var publicRepo = BehaviorSubject<String>(value: "")
    
    init(model: SearchUserItem, service: AppServices) {
        self.model = model
        if let login = model.login {
            service.mainService.rx.userInfo(userName: login)
                .observeOn(Schedulers.default)
                .subscribe(onNext: { [weak self] item in
                    self?.publicRepo.onNext("Number of repos: \(item.publicRepos ?? 0)")
                })
            .disposed(by: disposeBag)
        }
    }
}
