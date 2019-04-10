//
//  PicCollectionView.swift
//  wb
//
//  Created by 李元华 on 2019/3/19.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit
import SDWebImage

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
        
        NotificationCenter.default.post(name: ShowPhotoBrowserNotification, object: self, userInfo: userInfo)
    }
}

extension PicCollectionView: PhotoBrowserModalTransitionDelegate {
    func startRect(with indexPath: IndexPath?) -> CGRect? {
        guard let indexPath = indexPath else { return nil }
        guard let cell = cellForItem(at: indexPath) else { return nil }
        return convert(cell.frame, to: UIApplication.shared.keyWindow)
    }
    
    func endRect(with indexPath: IndexPath?) -> CGRect? {
        guard let indexPath = indexPath else { return nil }
        let URL = picURLArr[indexPath.item]
        guard let image = SDImageCache.shared.imageFromCache(forKey: URL.absoluteString) else {
            return nil
        }
        let height = MainWidth / image.size.width * image.size.height
        var y: CGFloat = 0
        if height > MainHeight {
            y = 0
        } else {
            y = (MainHeight - height) / 2
        }
        return CGRect(x: 0, y: y, width: MainWidth, height: height)
    }
    
    func animationView(with indexPath: IndexPath?) -> UIImageView? {
        guard let indexPath = indexPath else { return nil }
        let imageView = UIImageView()
        let URL = picURLArr[indexPath.item]
        guard let image = SDImageCache.shared.imageFromCache(forKey: URL.absoluteString) else {
            return nil
        }
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    
}
