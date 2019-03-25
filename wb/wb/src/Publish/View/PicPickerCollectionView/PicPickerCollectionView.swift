//
//  PicPickerCollectionView.swift
//  wb
//
//  Created by 李元华 on 2019/3/23.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class PicPickerCollectionView: UICollectionView {
    
    private let margin: CGFloat = 10
    private let picPickerCellID: String = "PicPickerCell"
    
    var pickImagesArr: [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        register(UINib(nibName: "PicPickerCollectionCell", bundle: nil), forCellWithReuseIdentifier: picPickerCellID)
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWh = Int(UIScreen.main.bounds.width - margin * 4) / 3
        
        layout.itemSize = CGSize(width: itemWh, height: itemWh)
        contentInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
    }

}

extension PicPickerCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickImagesArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCellID, for: indexPath) as! PicPickerCollectionCell
        
        cell.pickImage = indexPath.item <= pickImagesArr.count - 1 ? pickImagesArr[indexPath.item] : nil
        
        return cell
    }
}
