//
//  DrawView.swift
//  MNISTClassifier
//
//  Created by yusuf_kildan on 20.02.2018.
//  Copyright © 2018 yusuf_kildan. All rights reserved.
//

import UIKit

class Line {
    var start, end: CGPoint
    
    init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }
}

class DrawView: UIView {
    
    var lines: [Line] = []
    var lastPoint: CGPoint!
    
    var lineWidth: CGFloat = 15.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: - Touch Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = touches.first!.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newPoint = touches.first!.location(in: self)
        
        lines.append(Line(start: lastPoint, end: newPoint))
        lastPoint = newPoint

        setNeedsDisplay()
    }
    
    // MARK: - Draw
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let drawPath = UIBezierPath()
        drawPath.lineCapStyle = .round
        
        for line in lines{
            drawPath.move(to: line.start)
            drawPath.addLine(to: line.end)
        }
        
        drawPath.lineWidth = lineWidth
        lineColor.set()
        drawPath.stroke()
    }
    
    func getViewContext() -> CGContext? {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGImageAlphaInfo.none.rawValue
        
        let context = CGContext(data: nil, width: 28, height: 28, bitsPerComponent: 8, bytesPerRow: 28, space: colorSpace, bitmapInfo: bitmapInfo)

        context!.translateBy(x: 0 , y: 28)
        context!.scaleBy(x: 28/self.frame.size.width, y: -28/self.frame.size.height)

        self.layer.render(in: context!)
        
        return context
    }
}
