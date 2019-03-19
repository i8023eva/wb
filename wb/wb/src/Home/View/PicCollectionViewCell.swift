
//
//  PicCollectionViewCell.swift
//  wb
//
//  Created by 李元华 on 2019/3/19.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class PicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var picImgView: UIImageView!
    
    var picURL: URL? {
        didSet {
            guard let picURL = picURL else { return }
            
            picImgView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
}
