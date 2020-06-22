//
//  BaseVM.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/22.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import RxCocoa
import RxFlow

/**
 # (C) BaseVM
 - Author: Mephrine
 - Date: 20.06.22
 - Note: 모든 뷰모델이 상속받는 최상위 부모
*/
class BaseVM: Stepper {
    // 네비게이션 이동 관련
    lazy var steps = PublishRelay<Step>()
}
