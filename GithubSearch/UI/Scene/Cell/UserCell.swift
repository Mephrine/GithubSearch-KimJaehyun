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

final class UserCell: UITableViewCell, NibReusable {
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbRepoNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.ivAvatar.layer.cornerRadius = self.ivAvatar.bounds.height / 2
    }
    
    func configure(item: UserCellModel) {
        self.ivAvatar.kf.setImage(with: item.imageURL)
        self.lbName.text = item.userLoginID
        self.lbRepoNum.text = item.publicRepo
    }
}
