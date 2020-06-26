//
//  MainTableViewSection.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/23.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import RxDataSources

/**
 # (S) MainTableViewSection
 - Author: Mephrine
 - Date: 20.02.11
 - Note: 공인인증서 선택 화면 TableView에서 사용되는 Section 구조체
*/
struct MainTableViewSection {
    var items: [Item]
}

extension MainTableViewSection: SectionModelType {
    public typealias Item = UserCellModel
    
    init(original: MainTableViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
