//
//  HomeTableViewCell.swift
//  wb
//
//  Created by 李元华 on 2019/3/18.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

private let margin: CGFloat = 10.0

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var verifiedImgView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var vipImgView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var textLabelWidthConstraint: NSLayoutConstraint!
    
    
    var statusSession: StatusSession? {
        didSet {
            guard let statusSession = statusSession else {return}
            
            profileImgView.sd_setImage(with: statusSession.profileImgURLReplace, placeholderImage: UIImage(named: "avatar_default_small"))
            
            verifiedImgView.image = statusSession.verifiedTypeReplace
            
            screenNameLabel.text = statusSession.status?.user?.screen_name
            screenNameLabel.textColor = statusSession.mbrankReplace == nil ? UIColor.black : UIColor.orange
            
            timeLabel.text = statusSession.createdAtReplace
            
            sourceLabel.text = statusSession.sourceReplace
            
            vipImgView.image = statusSession.mbrankReplace
            
            contentLabel.text = statusSession.status?.text
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 具体的宽度约束， 而不是距左右
        textLabelWidthConstraint.constant = UIScreen.main.bounds.size.width * 0.5 - margin
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
