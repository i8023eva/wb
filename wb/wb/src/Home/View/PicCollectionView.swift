//
//  PicCollectionView.swift
//  wb
//
//  Created by 李元华 on 2019/3/19.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class PicCollectionView: UICollectionView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
    }
    /// 配图 URL
    var picURLArr: [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    
}

extension PicCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        
        cell.picURL = picURLArr[indexPath.item]
        
        return cell
    }
}

extension PicCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let userInfo: [String : Any] = [PhotoIndexPathKey : indexPath, PhotoURLArrKey : picURLArr]
        
        NotificationCenter.default.post(name: ShowPhotoBrowserNotification, object: nil, userInfo: userInfo)
    }
}
