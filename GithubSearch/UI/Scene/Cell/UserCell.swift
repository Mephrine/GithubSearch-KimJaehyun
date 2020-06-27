//
//  UserCell.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/23.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Kingfisher
import Reusable
import UIKit
import RxSwift
import RxAnimated

/**
# (C) UserCell
- Author: Mephrine
- Date: 20.06.23
- Note: 유저 정보를 보여주는 Cell
*/
final class UserCell: UITableViewCell, NibReusable {
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbRepoNum: UILabel!
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.ivAvatar.layer.cornerRadius = self.ivAvatar.bounds.height / 2
        self.ivAvatar.clipsToBounds = true
        self.ivAvatar.layer.masksToBounds = true
    }
    
    /**
     # configure
     - Author: Mephrine
     - Date: 20.06.23
     - Parameters:
         - item : Cell Model
     - Returns:
     - Note: Cell Model 정보를 Cell에 구성
    */
    func configure(item: UserCellModel) {
        self.ivAvatar.kf.setImage(with: item.imageURL,
                                  options: [.transition(.fade(ANIMATION_DURATION))])
        self.lbName.text = item.userLoginID
        
        item.publicRepo
            .distinctUntilChanged()
            .observeOn(Schedulers.main)
            .bind(to: self.lbRepoNum.rx.animated.fade(duration: ANIMATION_DURATION).text)
        .disposed(by: disposeBag)
    }
}
