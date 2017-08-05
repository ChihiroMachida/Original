//
//  GraphView.swift
//  Original
//
//  Created by 町田千優 on 2017/08/05.
//  Copyright © 2017年 町田千優. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    var _params: [Dictionary<String,AnyObject>]!
    var _end_angle: CGFloat!
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect,params:[Dictionary<String,AnyObject>]) {
        super.init(frame: frame)
        _params = params;
        self.backgroundColor = UIColor.clear;
        _end_angle = -CGFloat(Double.pi / 2.0);
    }
    
    
    func update(link:AnyObject){
        let angle = CGFloat(.pi*2.0 / 100.0);
        _end_angle = _end_angle +  angle
        if(_end_angle > CGFloat(Double.pi*2)) {
            //終了
            link.invalidate()
        } else {
            self.setNeedsDisplay()
        }
        
    }
    
    func startAnimating(){
        let displayLink = CADisplayLink(target: self, selector: Selector(("update:")))
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        var x:CGFloat = rect.origin.x;
        x += rect.size.width/2;
        var y:CGFloat = rect.origin.y;
        y += rect.size.height/2;
        var max:CGFloat = 0;
        for dic : Dictionary<String,AnyObject> in _params {
            let value = CGFloat(dic["value"] as! Float)
            max += value;
        }
        
        
        var start_angle: CGFloat = -CGFloat(Double.pi / 2);
        var end_angle: CGFloat    = 0;
        let radius: CGFloat  = x - 10.0;
        for dic : Dictionary<String,AnyObject> in _params {
            let value = CGFloat(dic["value"] as! Float)
            end_angle = start_angle + CGFloat(Double.pi*2) * (value/max);
            if(end_angle > _end_angle) {
                end_angle = _end_angle;
            }
            let color:UIColor = dic["color"] as! UIColor
            
            CGContextMoveToPoint(context, x, y);
            CGContextAddArc(context, x, y, radius,  start_angle, end_angle, 0);
            CGContextAddArc(context, x, y, radius/2,  end_angle, start_angle, 1);
            context.setFillColor(color.cgColor.components!);
            context.closePath();
            context.fillPath();
            start_angle = end_angle;
            
        }
        
    }

}
