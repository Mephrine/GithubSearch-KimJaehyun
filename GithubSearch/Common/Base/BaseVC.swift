//
//  BaseVC.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/22.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit
import Reusable

/**
 # (C) BaseVC.swift
 - Author: Mephrine
 - Date: 20.06.22
 - Parameters:
 - Returns:
 - Note: 모든 뷰컨트롤러가 상속받는 최상위 부모
*/
class BaseVC: UIViewController {
    // 상속된 현재 클래스 이름 리턴
    lazy private(set) var classNm: String = {
      return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    // PopGesture 플래그 변수
    private var isViewControllerPopGesture = true
    
    //제스쳐 관련 플래그 변수
    private var isPopGesture = true
    private var isPopSwipe = false
    
    var disposeBag = DisposeBag()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 자동으로 스크롤뷰 인셋 조정하는 코드 막기
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.initView()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setInteractivePopGesture(isViewControllerPopGesture)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isPopSwipe {
            if isPopGesture {
                popGesture()
            }
            isPopSwipe = false
        }
    }
    
    //MARK: - UI
    /**
     # initView
     - Author: Mephrine
     - Date: 20.06.22
     - Parameters:
     - Returns:
     - Note: ViewController에서 view 초기화 시에 실행할 내용 정의하는 Override용 함수
    */
    func initView() {
        
    }
    
    //MARK: - e.g.
    /**
     # popGesture
     - Author: Mephrine
     - Date: 20.06.22
     - Parameters:
     - Returns:
     - Note: ViewController에서 PopGesture시에 실행할 내용 정의하는 Override용 함수
    */
    func popGesture() {
        
    }
    
    /**
     # setInteractivePopGesture
     - Author: Mephrine
     - Date: 20.06.22
     - Parameters:
     - isRegi: PopGesture 적용 여부 Bool
     - Returns:
     - Note: ViewController PopGesture를 적용/해제하는 함수
     */
    func setInteractivePopGesture(_ isRegi:Bool = true) {
        if isRegi {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            isPopGesture = true
        } else {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            isPopGesture = false
        }
    }
    
    
    // MARK: SafeArea
    /**
     # safeAreaTopAnchor
     - Author: Mephrine
     - Date: 20.06.24
     - Parameters:
     - Returns: CGFloat
     - Note: 현재 디바이스의 safeAreaTop pixel값을 리턴하는 함수
    */
    var safeAreaTopAnchor: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            var topPadding = window?.safeAreaInsets.top
            
            if topPadding == 0 {
                topPadding = self.topLayoutGuide.length
                if topPadding == 0 {
                    topPadding = UIApplication.shared.statusBarFrame.size.height
                }
            }
            
            return topPadding ?? Utils.STATUS_HEIGHT
        } else {
            return Utils.STATUS_HEIGHT
        }
    }
    
    
    /**
     # safeAreaBottomAnchor
     - Author: Mephrine
     - Date: 20.06.22
     - Parameters:
     - Returns: CGFloat
     - Note: 현재 디바이스의 safeAreaBottom pixel값을 리턴하는 함수
    */
    var safeAreaBottomAnchor: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            return bottomPadding!
        } else {
            return bottomLayoutGuide.length
        }
    }
}


//MARK: -  UIGestureRecognizerDelegate.
// ViewController PopGesture 사용 / 해제를 위한 delegate 함수를 처리
extension BaseVC: UIGestureRecognizerDelegate {
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        switch gestureRecognizer.state {
        case .possible:
            isPopSwipe = true
            break
        case .began:
            isPopSwipe = true
            break
        case .changed:
            isPopSwipe = true
            break
        default:
            isPopSwipe = false
            break
        }
        return true
    }
}

// ViewModel과 같이 사용하는 용도.
//MARK: -  Storyboard & ViewModel로 ViewController 생성하는 용도.
extension View where Self: StoryboardBased & BaseVC {
    static func instantiate<ViewModelType> (withViewModel viewModel: ViewModelType) -> Self where ViewModelType == Self.Reactor {
        let viewController = Self.instantiate()
        viewController.reactor = viewModel
        return viewController
    }
    
    static func instantiate<ViewModelType> (withViewModel viewModel: ViewModelType, storyBoardName: String) -> Self where ViewModelType == Self.Reactor {
        let sb = UIStoryboard.init(name: storyBoardName, bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: String(describing: self)) as? Self {
            viewController.reactor = viewModel
            return viewController
        }
        return Self.instantiate(withViewModel: viewModel)
    }
}
