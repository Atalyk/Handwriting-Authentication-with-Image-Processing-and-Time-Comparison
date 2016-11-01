//
//  SignatureUploadViewController.swift
//  HandwritingSecurity
//
//  Created by Admin on 8/24/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

import UIKit

class SignatureUploadViewController: UIViewController {

    var drawView: DrawView!
    var submitButton = UIButton()
    var clearButton = UIButton()
    
    var image1 = UIImage(named: "natgeo")
    
    let screenBounds = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    func setup() {
        
        drawView = DrawView(frame: CGRect(x: screenBounds.width*0.1, y: screenBounds.width*0.1, width: screenBounds.width*0.8, height: screenBounds.width*0.8))
        drawView.backgroundColor = UIColor(red: 236/255, green: 239/255, blue: 241/255, alpha: 1.0)
        self.view.addSubview(drawView)
        
        submitButton = UIButton(frame: CGRect(x: screenBounds.width*0.2, y: screenBounds.height*0.55+100, width: screenBounds.width*0.6, height: 44))
        submitButton.backgroundColor = UIColor.blue
        submitButton.addTarget(self, action: #selector(createImageOfView), for: .touchUpInside)
        self.view.addSubview(submitButton)
        
        clearButton = UIButton(frame: CGRect(x: screenBounds.width*0.2, y: screenBounds.height*0.55, width: screenBounds.width*0.6, height: 44))
        clearButton.setTitle("Clear", for: UIControlState())
        clearButton.backgroundColor = UIColor.yellow
        clearButton.setTitleColor(UIColor.black, for: UIControlState())
        clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        self.view.addSubview(clearButton)
    }
    
    func createImageOfView() {
        UIGraphicsBeginImageContext(drawView.bounds.size)
        drawView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        image1 = viewImage
    }
    
    func clearButtonPressed() {
        drawView.clearDrawView()
    }

}
