//
//  ViewController.swift
//  Test_UUID
//
//  Created by JangHyeRyeong on 2021/03/12.
//

import UIKit
import AdSupport

class ViewController: UIViewController {

    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var UUIDLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UUIDLabel.numberOfLines = 0
        // Do any additional setup after loading the view.
        
        
    }

    
    
    @IBAction func touchUpSubmitUUID(_ sender: UIButton) {
        
        UUIDLabel.text = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        UUIDLabel.backgroundColor = getRandomColor()
        
        print(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
        print("\n-------------------")
        
    }
    
    func getRandomColor() -> UIColor{
            let randomRed:CGFloat = CGFloat(drand48())
            let randomGreen:CGFloat = CGFloat(drand48())
            let randomBlue:CGFloat = CGFloat(drand48())
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        }

}

