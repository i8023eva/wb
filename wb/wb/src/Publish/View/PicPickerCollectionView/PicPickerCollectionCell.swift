//
//  PicPickerCollectionCell.swift
//  wb
//
//  Created by 李元华 on 2019/3/23.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class PicPickerCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var pickImageView: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var removeImageBtn: UIButton!
    
    
    var pickImage: UIImage? {
        didSet {
            if pickImage != nil {
                pickImageView.image = pickImage
                addImageBtn.isUserInteractionEnabled = false
                removeImageBtn.isHidden = false
            } else {
                pickImageView.image = nil
                addImageBtn.isUserInteractionEnabled = true
                removeImageBtn.isHidden = true
            }
        }
    }
    

    @IBAction func addPicBtnClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: PicPickerCellAddNotification, object: nil)
    }
    
    @IBAction func removePicBtnClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: PicPickerCellRemoveNotification, object: pickImage)
    }
}
