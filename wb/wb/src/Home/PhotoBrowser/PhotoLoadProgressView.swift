//
//  PhotoLoadProgressView.swift
//  wb
//
//  Created by 李元华 on 2019/4/9.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class PhotoLoadProgressView: UIView {

    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundColor = .clear
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5 - 3
        let startAngle = CGFloat(-(Double.pi / 2))
        let endAngle = CGFloat(Double.pi * 2) * progress + startAngle
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addLine(to: center)
        path.close()
        UIColor(white: 1.0, alpha: 0.4).setFill()
        path.fill()
    }

}
