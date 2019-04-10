//
//  PhotoBrowserViewController.swift
//  wb
//
//  Created by 李元华 on 2019/4/9.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit
import SVProgressHUD

private let PhotoBrowserCellID = "PhotoBrowserCellID"

class PhotoBrowserViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    private lazy var saveButton: UIButton = UIButton(title: "保 存")
    private lazy var closeButton: UIButton = UIButton(title: "关 闭")
    
    var indexPath: IndexPath
    var picURLArr: [URL]
    
    
    init(indexPath: IndexPath, picURLArr: [URL]) {
        self.indexPath = indexPath
        self.picURLArr = picURLArr
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        // MARK: 为collectionitem 加间距
        view.bounds.size.width += 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubView()
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}

extension PhotoBrowserViewController {
    private func setupSubView() {
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        view.addSubview(closeButton)
        
        collectionView.frame = view.bounds
        collectionView.register(PhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCellID)
        collectionView.dataSource = self
        
        saveButton.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-64)
            make.size.equalTo(CGSize(width: 80, height: 35))
        }
        closeButton.snp_makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(-64)
            make.size.equalTo(saveButton.snp_size)
        }
        saveButton.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
    }
    
    @objc private func saveBtnClick() {
        let cell = collectionView.visibleCells.first as! PhotoBrowserCollectionViewCell
        guard let image = cell.imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc private func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
//    - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        var finshInfo = ""
        if error != nil {
            finshInfo = "保存失败"
        } else {
            finshInfo = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: finshInfo)
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoBrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCellID, for: indexPath) as! PhotoBrowserCollectionViewCell
        cell.picURL = picURLArr[indexPath.item]
        cell.delegate = self
        return cell
    }
}

// MARK: - PhotoBrowserCollectionViewCellDelegate
extension PhotoBrowserViewController: PhotoBrowserCollectionViewCellDelegate {
    func imageViewTap() {
        closeBtnClick()
    }
}

class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        itemSize = collectionView!.frame.size
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}


