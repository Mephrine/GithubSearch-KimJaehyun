//
//  Utils.swift
//  GithubSearchTests
//
//  Created by Mephrine on 2020/06/23.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import SwiftyJSON

func jsonStringToData<T>(_ jsonString: String) -> T? {
    if let data = jsonString.removingAllWhitespacesAndNewlines.data(using: .utf8) {
        do {
            let json = try JSON(data: data)
            
            let returnData = json.to(type: T.self) as? T
            return returnData
        } catch {}
    }
    return nil
}
