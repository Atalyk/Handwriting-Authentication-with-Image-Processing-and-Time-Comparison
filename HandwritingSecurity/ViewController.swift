//
//  ViewController.swift
//  HandwritingSecurity
//
//  Created by Admin on 8/19/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

import UIKit
import Parse

extension UIView {
    func addDashedLine(_ color: UIColor = UIColor.gray) {
        
        let screenBounds = UIScreen.main.bounds
        
        layer.sublayers?.filter({ $0.name == "DashedTopLine" }).map({ $0.removeFromSuperlayer() })
        self.backgroundColor = UIColor.clear
        let cgColor = color.cgColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: screenBounds.width*0.1, y: screenBounds.height*0.1, width: screenBounds.width*0.8, height: 44)
        
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height*0.9)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [10, 10]
        
        let path: CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
}

class ViewController: UIViewController {
    
    var drawView: DrawView!
    var submitButton = UIButton()
    var clearButton = UIButton()
    
    var submitButtonOne = UIButton()
    
    var lineView = UIView()
    
    var image1 = UIImage(named: "natgeo")
    var image2 = UIImage(named: "natgeo-1")
    
    var imageView = UIImageView()

    let screenBounds = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

    }
    
    func setup() {
        
        drawView = DrawView(frame: CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height))
        drawView.backgroundColor = UIColor.white
        self.view.addSubview(drawView)
        
        submitButton = UIButton(frame: CGRect(x: 40, y: screenBounds.height*0.8, width: 44, height: 44))
        submitButton.setImage(UIImage(named: "success"), for: UIControlState())
        submitButton.contentMode = .center
        submitButton.addTarget(self, action: #selector(submitResults), for: .touchUpInside)
        self.view.addSubview(submitButton)
        
        submitButtonOne = UIButton(frame: CGRect(x: 100, y: screenBounds.height*0.8, width: 44, height: 44))
        submitButtonOne.setImage(UIImage(named: "success"), for: UIControlState())
        submitButtonOne.contentMode = .center
        submitButtonOne.layer.cornerRadius = 22
        submitButtonOne.backgroundColor = UIColor.green
        submitButtonOne.addTarget(self, action: #selector(createImageOneOfView), for: .touchUpInside)
        self.view.addSubview(submitButtonOne)
        
        clearButton = UIButton(frame: CGRect(x: screenBounds.width*0.9, y: screenBounds.height*0.8, width: 44, height: 44))
        clearButton.setImage(UIImage(named: "erase"), for: UIControlState())
        clearButton.contentMode = .center
        clearButton.setTitleColor(UIColor.black, for: UIControlState())
        clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        self.view.addSubview(clearButton)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.view.addSubview(imageView)
        
        view.addDashedLine()

    }
    
    func compareImages() {
        let instanceOfCustomObject: CustomObject = CustomObject()
        instanceOfCustomObject.someMethod(image1, image2)
    }
    
    func createImageOfView() {
        print("hey ")
        UIGraphicsBeginImageContext(drawView.bounds.size)
        drawView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        image2 = viewImage
    }
    
    func createImageOneOfView() {
        UIGraphicsBeginImageContext(drawView.bounds.size)
        drawView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        image1 = viewImage
        imageView.image = viewImage
    }
    
    func clearButtonPressed() {
        drawView.clearDrawView()
    }
    
    func submitResults() {
        createImageOfView()
        let instanceOfCustomObject: CustomObject = CustomObject()
        if instanceOfCustomObject.someMethod(image1, image2) {
            let array = drawView.getSecondsArray()
            instanceOfCustomObject.supportVectorMachine(array)
        }
    }
    
}

