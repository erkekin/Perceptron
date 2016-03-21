
//  PerceptronView
//  Perceptron
//
//  Created by Erk EKİN on 22/11/15.
//  Copyright © 2016 Erk Ekin. All rights reserved.
//

import UIKit
import Accelerate

class Node {
    
    var point:CGPoint!
    var layer:CAShapeLayer!
    var sinif:Int = -1
    
    init(point:CGPoint, layer:CAShapeLayer,sinif:Int){
        
        self.point = point
        self.layer = layer
        self.sinif = sinif
    }
}

class PerceptronView: UIView {
    
    var nodes:[Node] = []
    var perceptron = Perceptron()
    var sinif = -1
    @IBOutlet var control:UISegmentedControl!
    
    var modelLine:CAShapeLayer?
    let gridWidth: CGFloat = 0.5
    var columns: Int = 25
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.opaque = false;
        self.backgroundColor = UIColor.whiteColor()
        
        let tap = UITapGestureRecognizer(target: self, action: "test:")
        self.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: "tapped:")
        self.addGestureRecognizer(pan)
        
        let longTap = UILongPressGestureRecognizer(target: self, action: "removeAll")
        self.addGestureRecognizer(longTap)
        
    }
    
    @IBAction func changeClass(sender: UISegmentedControl) {
        
        self.sinif = (self.sinif == -1) ? 1 : -1
        
        sender.tintColor = (self.sinif == 1) ? UIColor.redColor(): UIColor.blueColor()
        
    }
    
    func tapped(sender: UITapGestureRecognizer) {
        
        switch sender.state{
            
        case .Began:
            
            
            break
        case .Ended:
            perceptron = Perceptron()
            let inputs = self.nodes.map({[Double($0.point.x), Double($0.point.y)]})
            let outputs = self.nodes.map({Double($0.sinif)})
            
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue) { () -> Void in
                
                self.perceptron.train(inputs: inputs, outputs: outputs, learningRate: 0.5, epsilon: 0.001)
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.drawModel()
                })
                
            }
            
            break
        case .Cancelled:
            
            break
        case .Failed:
            
            break
        case .Changed:
            
            let tapPositionOneFingerTap = sender.locationInView(self)
            let node = Node(point: tapPositionOneFingerTap, layer: self.drawPoint(tapPositionOneFingerTap, color: self.sinif == 1 ? UIColor.redColor().CGColor :  UIColor.blueColor().CGColor), sinif: self.sinif)
            self.nodes.append(node)
            
            self.layer.addSublayer(node.layer)
            
            break
            
        default:
            
            break
        }
        
    }
    
    func test(sender: UITapGestureRecognizer) {
        
        let tapPositionOneFingerTap = sender.locationInView(self)
        
        let inputs = [Double(tapPositionOneFingerTap.x), Double(tapPositionOneFingerTap.y)]
        
        if perceptron.test(inputs) == 1 {
            control.selectedSegmentIndex = 0
            control.tintColor = UIColor.redColor()
        }else {
            control.selectedSegmentIndex = 1
            control.tintColor = UIColor.blueColor()
        }
    }
    
    func removeAll(){
        
        modelLine?.removeFromSuperlayer()
        for onelayer in nodes{
            
            onelayer.layer.removeFromSuperlayer()
            
        }
        
        self.nodes = []
        perceptron = Perceptron()
    }
    
    // MARK: Drawing
    
    func drawModel(){
        
        modelLine?.removeFromSuperlayer()
        modelLine = drawLinearModel()
        self.layer.addSublayer(self.modelLine!)
        
    }
    
    func drawLinearModel() -> CAShapeLayer
    {
        //https://www.willamette.edu/~gorr/classes/cs449/Classification/perceptron.html
        var elements = [Double](count: Int(la_matrix_rows(perceptron.neuron.weight) * la_matrix_cols(perceptron.neuron.weight)), repeatedValue: Double(0.0))
        la_matrix_to_double_buffer(&elements, la_matrix_cols(perceptron.neuron.weight), perceptron.neuron.weight)
        
        let w1 = elements[1]; let w2 = elements[2]; let w3 = elements[0]
        let x0 = 0.0
        let y0 = -1 * (w1/w2) * x0 - w3 / w2
        
        let x1 = Double(frame.width)
        let y1 = -1 * (w1/w2) * x1 - w3 / w2
        
        let axialPoints = (x0: CGPointMake(CGFloat(x0), CGFloat(y0)),x1: CGPointMake(CGFloat(x1), CGFloat(y1)))
        
        return lineBetweenPoints(axialPoints.x0, p2: axialPoints.x1)
        
    }
    
    func lineBetweenPoints(p1:CGPoint, p2: CGPoint) -> CAShapeLayer{
        
        let rwColor = UIColor.blueColor()
        let rwPath = UIBezierPath()
        let rwLayer = CAShapeLayer()
        rwPath.moveToPoint(p1)
        rwPath.addLineToPoint(p2)
        rwPath.closePath()
        rwLayer.path = rwPath.CGPath
        rwLayer.lineWidth = 1.0
        rwLayer.fillColor = rwColor.CGColor
        rwLayer.strokeColor = rwColor.CGColor
        
        return rwLayer
    }
    
    func drawPoint(point:CGPoint, color:CGColor) -> CAShapeLayer{
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: point.x - 2.5, y: point.y - 2.5, width: 5, height: 5), cornerRadius: 2.5).CGPath
        layer.fillColor = color
        return layer
        
    }
    
    override func drawRect(rect: CGRect) {
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetLineWidth(context, gridWidth)
        CGContextSetStrokeColorWithColor(context, UIColor(red:0.73, green:0.84, blue:0.95, alpha:1).CGColor)
        
        // Calculate basic dimensions
        let columnWidth: CGFloat = self.frame.size.width / (CGFloat(self.columns) + 1.0)
        let rowHeight: CGFloat = columnWidth;
        let numberOfRows: Int = Int(self.frame.size.height)/Int(rowHeight);
        
        // ---------------------------
        // Drawing column lines
        // ---------------------------
        for i in 1...self.columns {
            let startPoint: CGPoint = CGPoint(x: columnWidth * CGFloat(i), y: 0.0)
            let endPoint: CGPoint = CGPoint(x: startPoint.x, y: self.frame.size.height)
            
            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
            CGContextStrokePath(context);
        }
        
        // ---------------------------
        // Drawing row lines
        // ---------------------------
        for j in 1...numberOfRows {
            let startPoint: CGPoint = CGPoint(x: 0.0, y: rowHeight * CGFloat(j))
            let endPoint: CGPoint = CGPoint(x: self.frame.size.width, y: startPoint.y)
            
            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
            CGContextStrokePath(context);
        }
    }
    
}