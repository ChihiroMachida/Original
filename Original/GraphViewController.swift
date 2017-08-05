//
//  GraphViewController.swift
//  Original
//
//  Created by 町田千優 on 2017/08/05.
//  Copyright © 2017年 町田千優. All rights reserved.
//

import UIKit

struct Segment {
    
    // MARK: セグメントの背景色
    var color : UIColor = UIColor.black
    
    // MARK: セグメントの割合を設定する変数（比率）
    var value : CGFloat = 10.0
}

class PieChartView: UIView {
    var segments = [Segment]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func draw(_ rect: CGRect) {
        
        // MARK: CGContextの初期化
        let ctx = UIGraphicsGetCurrentContext()
        
        // MARK: 円型にするためにradiusを設定
        let radius = min(frame.size.width, frame.size.height)/2
        
        // MARK: Viewの中心点を取得
        let viewCenter = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        
        // MARK: セグメントごとの比率に応じてグラフを変形するための定数
        let valueCount = segments.reduce(0) {$0 + $1.value}
        
        // MARK: 円グラフの起点を設定 [the starting angle is -90 degrees (top of the circle, as the context is flipped). By default, 0 is the right hand side of the circle, with the positive angle being in an anti-clockwise direction (same as a unit circle in maths).]
        var startAngle = -CGFloat(Double.pi*0.5)
        
        // MARK: 初期化されたすべてのセグメントを描画するための処理
        for segment in segments { // loop through the values array
            ctx?.setFillColor(segment.color.cgColor)
            let endAngle = startAngle+CGFloat(Double.pi*2)*(segment.value/valueCount)
            ctx?.move(to: CGPoint(x:viewCenter.x, y: viewCenter.y))
            ctx?.addArc(center: CGPoint(x:viewCenter.x, y: viewCenter.y), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            ctx?.fillPath()
            startAngle = endAngle
        }
    }
}
