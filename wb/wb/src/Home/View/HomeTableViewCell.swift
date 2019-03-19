//
//  HomeTableViewCell.swift
//  wb
//
//  Created by 李元华 on 2019/3/18.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit
import SDWebImage

private let margin: CGFloat = 10.0

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var verifiedImgView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var vipImgView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picCollectionView: PicCollectionView!
    
//    @IBOutlet weak var textLabelWidthConstraint: NSLayoutConstraint!
    ///
    @IBOutlet weak var picCollectionWidthCons: NSLayoutConstraint!
    @IBOutlet weak var picCollectionHeightCons: NSLayoutConstraint!
    
    /// item 宽高
    let collectionCellHW: CGFloat = (UIScreen.main.bounds.width - 4 * margin) / 3
    
    
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
            
            let collectionSize = getPicCollectionSize(count: statusSession.picURLsReplace.count)
            picCollectionWidthCons.constant = collectionSize.width
            picCollectionHeightCons.constant = collectionSize.height
            
            picCollectionView.picURLArr = statusSession.picURLsReplace
        }
    }
    
    // 只设置一次
    override func awakeFromNib() {
        super.awakeFromNib()
        // 具体的宽度约束，而不是距左右，不然估算高度有问题 ;  也可以设置右边 >= 10
//        textLabelWidthConstraint.constant = UIScreen.main.bounds.width - margin * 2
        
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// FIXME: UIViewAlertForUnsatisfiableConstraints 约束
/*
 collection 高度可能为 0， 上下两个约束有冲突, 改优先级priority
 */

extension HomeTableViewCell {
    /// 根据图片个数获取 collection 大小
    private func getPicCollectionSize(count: Int) -> CGSize {
        
        // 0
        if count == 0 {
            return CGSize.zero
        }
        
        // 1  单张配图新浪没有给具体的大小，等比例显示就先下载
        let layout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        if count == 1 {
            let URLString = statusSession?.picURLsReplace.first?.absoluteString
            // MemoryCache 没取到值
            if let URLImage = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: URLString) {
                layout.itemSize = CGSize(width: URLImage.size.width, height: URLImage.size.height)
                
                return CGSize(width: URLImage.size.width, height: URLImage.size.height)
            }
            return CGSize.zero
        }
        
        layout.itemSize = CGSize(width: collectionCellHW, height: collectionCellHW)
        
        // 4
        if count == 4 {
            let collectionHW = collectionCellHW * 2 + margin
            return CGSize(width: collectionHW, height: collectionHW)
        }
        
        // n
        let rows = CGFloat((count - 1) / 3 + 1)
        
        let collectionH = collectionCellHW * rows + margin * (rows - 1)
        let collectionW = UIScreen.main.bounds.width - margin * 2
        
        return CGSize(width: collectionW, height: collectionH)
    }
}
