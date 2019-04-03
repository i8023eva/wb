//
//  EmoticonCollectionViewCell.swift
//  表情键盘
//
//  Created by 李元华 on 2019/3/26.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class EmoticonCollectionViewCell: UICollectionViewCell {
    
    private lazy var emoticonBtn: UIButton = UIButton()
    
    var emoticonSession: EmoticonSession? {
        didSet {
            guard let emoticonSession = emoticonSession else { return }
            
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticonSession.png ?? "timg"), for: .normal)
            emoticonBtn.setTitle(emoticonSession.code, for: .normal)
            
            if emoticonSession.emoticon!.isRemove {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
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

extension EmoticonCollectionViewCell {
    
    private func setupSubView() {
        
        contentView.addSubview(emoticonBtn)
        
        emoticonBtn.frame = contentView.bounds
//        改变 emoji 字符的大小
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        emoticonBtn.isUserInteractionEnabled = false
    }
}

