//
//  CommonAlert.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/22.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import UIKit

open class CommonAlert {
    
    /**
     # showAlert
     - Author: Mephrine
     - Date: 20.05.28
     - Parameters:
        - vc: 알럿을 띄울 뷰컨트롤러
        - title: 알럿 타이틀명
        - message: 알럿 메시지
        - completeTitle: 버튼명
        - completeHandler: 버튼 클릭 시, 실행될 클로저
     - Returns:
     - Note: 버튼이 1개인 기본 알럿을 띄우는 함수
    */
    public static func showAlert(vc: UIViewController? = nil, title: String = "", message: String = "", completeTitle: String = "확인", _ completeHandler:(() -> Void)? = nil){
        
        if let viewController = vc ?? UIApplication.applicationWindow.visibleViewController {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertController.Style.alert)
                let action1 = UIAlertAction(title:completeTitle, style: .default) { action in
                    completeHandler?()
                }
                alert.addAction(action1)
                
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /**
        # showConfirm
        - Author: Mephrine
        - Date: 20.05.28
        - Parameters:
           - vc: 알럿을 띄울 뷰컨트롤러
           - title: 알럿 타이틀명
           - message: 알럿 메시지
           - cancelTitle: 취소 버튼명
           - completeTitle: 확인 버튼명
           - cancelHandler: 취소 버튼 클릭 시, 실행될 클로저
           - completeHandler: 확인 버튼 클릭 시, 실행될 클로저
        - Returns:
        - Note: 버튼이 2개인 기본 알럿을 띄우는 함수
       */
    public static func showConfirm(vc: UIViewController? = nil, title: String = "", message: String = "", cancelTitle: String = "취소", completeTitle: String = "확인",  _ cancelHandler: (() -> Void)? = nil, _ completeHandler: (() -> Void)? = nil){
        if let viewController = vc ?? UIApplication.applicationWindow.visibleViewController {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertController.Style.alert)
                let action1 = UIAlertAction(title:cancelTitle, style: .cancel) { action in
                    cancelHandler?()
                }
                let action2 = UIAlertAction(title:completeTitle, style: .default) { action in
                    completeHandler?()
                }
                alert.addAction(action1)
                alert.addAction(action2)
                
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
}

