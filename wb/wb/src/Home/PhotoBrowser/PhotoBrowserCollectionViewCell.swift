//
//  PhotoBrowserCollectionViewCell.swift
//  wb
//
//  Created by 李元华 on 2019/4/9.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserCollectionViewCell: UICollectionViewCell {
    
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var imageView: UIImageView = UIImageView()
    private lazy var progressView: PhotoLoadProgressView = PhotoLoadProgressView()
    
    var picURL: URL? {
        didSet {
            didSetPicURL(picURL: picURL)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PhotoBrowserCollectionViewCell {
    private func setupSubView() {
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        scrollView.frame = contentView.bounds
        progressView.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        progressView.center = CGPoint(x: MainWidth / 2, y: MainHeight / 2)
        progressView.isHidden = true
    }
    
    private func didSetPicURL(picURL: URL?) {
        guard let picURL = picURL else { return }
        guard let image = SDImageCache.shared.imageFromCache(forKey: picURL.absoluteString) else { return }
        
        let height = MainWidth / image.size.width * image.size.height
        var y: CGFloat = 0
        if height > MainHeight {
            y = 0
        } else {
            y = (MainHeight - height) * 0.5
        }
        imageView.frame = CGRect(x: 0, y: y, width: MainWidth, height: height)
        self.progressView.isHidden = false
        imageView.sd_setImage(with: getBmiddleURL(picURL: picURL), placeholderImage: image, options: [], progress: { (current, total, _) in
            self.progressView.progress = CGFloat(current) / CGFloat(total)
        }) { (_, error, _, _) in
            self.progressView.isHidden = true
        }
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    
    private func getBmiddleURL(picURL: URL) -> URL {
        return URL(string: picURL.absoluteString.replacingOccurrences(of: "thumbnail", with: "bmiddle")) ?? picURL
    }
}
