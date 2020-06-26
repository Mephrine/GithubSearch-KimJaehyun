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
    }
    
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
