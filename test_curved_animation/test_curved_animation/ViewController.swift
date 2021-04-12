//
//  ViewController.swift
//  test_curved_animation
//
//  Created by 장혜령 on 2021/04/12.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var movedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let myCurvePath = curvedView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2))
        myCurvePath.backgroundColor = .clear
        self.view.addSubview(myCurvePath)
        addPointView()
    }
    
    func addCurvedAnimation(){
        let myPath = setBezierPath()
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = myPath.cgPath
        anim.rotationMode = CAAnimationRotationMode.rotateAuto
        anim.repeatCount = 5
        anim.duration = 2.0
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        movedView.layer.add(anim, forKey: "animate position along path")
    }

    
    func setBezierPath() -> UIBezierPath{
        let myPath = UIBezierPath()
        myPath.move(to: CGPoint(x: 100 , y: 400)) // start point
        myPath.addCurve(to: CGPoint(x: 300, y: 100),
                      controlPoint1: CGPoint(x: 100, y: 200),
                      controlPoint2: CGPoint(x: 300, y: 200))
        UIColor.orange.set()
        //myPath.close()
        myPath.stroke()
        return myPath
    }
    
    func addPointView(){
        let point1 = UIView()
        point1.frame = CGRect(x: 100, y: 400, width: 3, height: 3)
        point1.backgroundColor = .red
        
        
        let point2 = UIView()
        point2.frame = CGRect(x: 300, y: 100, width: 3, height: 3)
        point2.backgroundColor = .blue
        
        self.view.addSubview(point1)
        self.view.addSubview(point2)
        
    }
    
    @IBAction func startToMove(_ sender: Any) {
        addCurvedAnimation()
    }
    
}

class curvedView: UIView{
    override func draw(_ rect: CGRect) {
        let myPath = UIBezierPath()
        myPath.move(to: CGPoint(x: 100 , y: 400)) // start point
        myPath.addCurve(to: CGPoint(x: 300, y: 100),
                      controlPoint1: CGPoint(x: 100, y: 200),
                      controlPoint2: CGPoint(x: 300, y: 200))
        UIColor.orange.set()
        
        myPath.stroke()
    }
}
