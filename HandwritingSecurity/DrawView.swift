//
//  DrawView.swift
//  Mandarin
//
//  Created by Admin on 8/19/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var secondsLabel = UILabel()
    
    var lines = [Line]()
    var lastPoint: CGPoint!
    var newPoint: CGPoint!
    var timer = Timer()
    var seconds = 0
    var overallSignTime = 0
    var countTouches = 0
    var secondsArray = [Int]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.backgroundColor = UIColor.white.cgColor
        
        secondsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        self.addSubview(secondsLabel)
        
        overallSignTime = 0
        countTouches = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        countTouches = countTouches + 1
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
        startTimer()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            newPoint = touch.location(in: self)
        }
        lines.append(Line(start: lastPoint, end: newPoint))
        lastPoint = newPoint
        
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        timer.invalidate()
        secondsArray.append(seconds)
        print("\(seconds)")
    }
    
    func startTimer() {
        seconds = 0
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(DrawView.timerAction), userInfo: nil, repeats: true)
    }
    
    func timerAction() {
        seconds = seconds + 1
    }
    

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        for line in lines {
            context?.move(to: CGPoint(x: line.start.x, y: line.start.y))
            context?.addLine(to: CGPoint(x: line.end.x, y: line.end.y))
        }
        context?.setLineCap(CGLineCap.round)
        context?.setStrokeColor(red: 1, green: 0, blue: 0, alpha: 1)
        context?.setLineWidth(5)
        context?.strokePath()
    }
    
    func clearDrawView() {
        lines = []
        self.setNeedsDisplay()
        countTouches = 0
        secondsArray.removeAll()
    }
    
    func getSecondsArray() -> Array<Int> {
        return secondsArray
    }
    
}
