//
//  AppFlow.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/22.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import RxCocoa
import RxFlow
import RxSwift
import UIKit
import SafariServices

/**
 # (C) AppFlow
 - Author: Mephrine
 - Date: 20.06.22
 - Note: 메인화면 네비게이션 관리 Flow.
*/
class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    private let service: AppServices
    
    init(service: AppServices) {
        self.service = service
    }
    
    deinit {
        log.d("deinit MainFlow")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .goMain:
            return naviToMain()
        default:
            return .none
        }
    }
    
    // 메인화면 띄우기.
    private func naviToMain() -> FlowContributors {
        let viewModel = MainVM(withService: service)
        let mainVC = MainVC.instantiate(withViewModel: viewModel, storyBoardName: "Main")
        self.rootViewController.setViewControllers([mainVC], animated: false)
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: mainVC, withNextStepper: viewModel))
    }
}

/** 
 # (C) AppStepper
 - Author: Mephrine
 - Date: 20.06.22
 - Note: 첫 Flow 실행을 위한 Stepper
*/
class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    private let appServices: AppServices
    
    init(withService service: AppServices) {
        self.appServices = service
    }
    
    var initialStep: Step {
        return AppStep.goMain
    }
    
    // FlowCoordinator가 Flow에 기여하기 위해 청취할 준비가 되면 step을 한번 방출하는데 사용되어지는 callback.
    func readyToEmitSteps() {
        
    }
}
