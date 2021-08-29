//
//  HeaderView.swift
//  MusicGen
//
//  Created by Kartinin Studio on 10.06.2021.
//

import Foundation
import UIKit

class HeaderView: UIView {
    //MARK: - PROPERTIES
    var triangleView = UIView()
    
    //MARK: - LIFE CYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
        backgroundColor = .purpleApp
        let figures = UIView()
        self.addSubview(figures)
        //let image = UIImage(named: "knob_bpm1X")
        figures.backgroundColor = UIColor(patternImage: UIImage(named: "figure1X")!)
        figures.anchor(bottom: bottomAnchor, right: self.rightAnchor, paddingBottom: 10, paddingRight: 10, width: 46, height: 10)
        
        /*addSubview(triangleView)
        triangleView.anchor(top: self.topAnchor, right: self.rightAnchor, paddingTop: 10, paddingRight: 10)
        drawRectangle()
        drawTriangle()
        drawOval()*/
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - HELPER FUNCTIONS
    private func drawRectangle() {
            
            let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addLine(to: CGPoint(x: 10, y: 10))
            path.addLine(to: CGPoint(x: 0, y: 10))
            path.addLine(to: CGPoint(x: 0, y: 0))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.purpleLightApp.cgColor
            shapeLayer.fillColor = UIColor.purpleLightApp.cgColor
            shapeLayer.lineWidth = 3
            let viewRect = UIView()
        self.addSubview(viewRect)
        viewRect.layer.addSublayer(shapeLayer)
        viewRect.anchor(top: self.safeAreaLayoutGuide.topAnchor, right: self.rightAnchor, paddingTop: 0, paddingRight: 60)
        
        }
    private func drawTriangle() {
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: 10))
            path.addLine(to: CGPoint(x: 5, y: 0))
            path.addLine(to: CGPoint(x: 10, y: 10))
            path.addLine(to: CGPoint(x: 0, y: 10))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.purpleLightApp.cgColor
            shapeLayer.fillColor = UIColor.purpleLightApp.cgColor
            shapeLayer.lineWidth = 3
            
        let viewTriangle = UIView()
    self.addSubview(viewTriangle)
        viewTriangle.layer.addSublayer(shapeLayer)
        viewTriangle.anchor(top: self.safeAreaLayoutGuide.topAnchor, right: self.rightAnchor, paddingTop: 0, paddingRight: 20)
           
        }
    private func drawOval() {
        let viewOval = UIView()
        viewOval.frame = CGRect.init(x: 0, y: 0, width: 10, height: 10)
        viewOval.backgroundColor = UIColor.purpleLightApp
        self.addSubview(viewOval)
        viewOval.anchor(top: self.safeAreaLayoutGuide.topAnchor, right: self.rightAnchor, paddingTop: 0, paddingRight: 20, width: 20, height: 20)
        viewOval.layer.cornerRadius = 10
        }
}
