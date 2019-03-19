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
    }
    
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
