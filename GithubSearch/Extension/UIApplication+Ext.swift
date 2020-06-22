//
//  UIApplication+Ext.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/22.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import UIKit

extension UIApplication {
    static var applicationWindow: UIWindow {
        return (UIApplication.shared.delegate?.window?.flatMap { $0 })!
    }
}
