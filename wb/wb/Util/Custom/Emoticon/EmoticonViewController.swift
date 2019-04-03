//
//  EmoticonViewController.swift
//  表情键盘
//
//  Created by 李元华 on 2019/3/25.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class EmoticonViewController: UIViewController {
    
    private let EmoticonCell: String = "EmoticonCell"
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())
    
    private lazy var toolBar: UIToolbar = UIToolbar()
    
    private lazy var emojiManager: EmoticonManager = EmoticonManager()
    
    var emoticonHandle: (_ emoticon: Emoticon) -> ()
    
    init(emoticonHandle: @escaping (_ emoticon: Emoticon) -> ()) {
        // 属性初始化  循环引用
        self.emoticonHandle = emoticonHandle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubView()
    }
}

extension EmoticonViewController {
    
    private func setupSubView() {
        
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        collectionView.backgroundColor = UIColor(displayP3Red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        var bottomInt = 0
        if UIDevice.current.name.contains("X"){
            bottomInt = 34
        }
        let bottomNum = NSNumber(value: bottomInt)
        
        let views = ["toolBar" : toolBar, "collectionView" : collectionView]
        let metrics = ["bottomMargin" : bottomNum]
        
        var constraintArr = NSLayoutConstraint.constraints(withVisualFormat: "H:|[toolBar]|", options: [], metrics: nil, views: views)
        constraintArr += NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView][toolBar]-(bottomMargin)-|", options: [.alignAllTrailing, .alignAllLeading], metrics: metrics, views: views)
        
//        NSLayoutConstraint.activate(constraintArr)
        view.addConstraints(constraintArr)
        
        setupCollection()
        
        setupToolBar()
    }
    
    private func setupCollection() {
        collectionView.register(EmoticonCollectionViewCell.self, forCellWithReuseIdentifier: EmoticonCell)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    private func setupToolBar() {
        
        let titleArr = ["最近", "默认", "emoji", "浪小花"]
        
        var items: [UIBarButtonItem] = [UIBarButtonItem]()
        var index = 0
        for title in titleArr {
            
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(EmoticonViewController.itemClick(item:)))
            item.tag = index
            
            items.append(item)
            
            index += 1
            
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
        toolBar.tintColor = UIColor.orange
    }
    
    @objc private func itemClick(item: UIBarButtonItem) {
        
        let tag = item.tag
        
        let indexPath = IndexPath(item: 0, section: tag)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension EmoticonViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiManager.packageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiManager.packageArr[section].emoticonArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCell, for: indexPath) as! EmoticonCollectionViewCell
        
        let package = emojiManager.packageArr[indexPath.section]
        let emoticon = package.emoticonArr[indexPath.item]
        cell.emoticonSession = EmoticonSession(emoticon: emoticon)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension EmoticonViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let package = emojiManager.packageArr[indexPath.section]
        let emoticon = package.emoticonArr[indexPath.item]
        
        insertRecentlyEmoticon(emoticon: emoticon)
//        传出点击的
        emoticonHandle(emoticon)
    }
    
    private func insertRecentlyEmoticon(emoticon: Emoticon) {
//        最近
        guard let recentlyPackage = emojiManager.packageArr.first else {return}
//        空白 删除按钮
        if emoticon.isRemove || emoticon.isEmpty { return }
//        如果表情存在
        if recentlyPackage.emoticonArr.contains(emoticon) {
            
            if let index = recentlyPackage.emoticonArr.firstIndex(of: emoticon) {
                recentlyPackage.emoticonArr.remove(at: index)
            }
        } else {
            recentlyPackage.emoticonArr.remove(at: 19)
        }
        
        emojiManager.packageArr.first?.emoticonArr.insert(emoticon, at: 0)
    }
}

class EmoticonCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        let itemWH = (UIScreen.main.bounds.width) / 7
        itemSize = CGSize(width: itemWH, height: itemWH)
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        scrollDirection = .horizontal
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        
        let insetMargin: CGFloat = ((collectionView?.bounds.height)! - 3 * itemWH) / 2 - 1
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
}

