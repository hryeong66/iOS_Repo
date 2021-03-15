//
//  ViewController.swift
//  Test_UUID
//
//  Created by JangHyeRyeong on 2021/03/12.
//

import UIKit
import AdSupport
import AppTrackingTransparency

class ViewController: UIViewController {

    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var permissionBtn: UIButton!
    @IBOutlet weak var ADUUIDLabel: UILabel!
    @IBOutlet weak var VDUUIDLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ADUUIDLabel.numberOfLines = 0
        VDUUIDLabel.numberOfLines = 0
        // Do any additional setup after loading the view.
        
    }

    
    @IBAction func touchUpSubmitUUID(_ sender: UIButton) {
        let myAdUUID = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        ADUUIDLabel.text = myAdUUID
        ADUUIDLabel.backgroundColor = getRandomColor()
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            VDUUIDLabel.text = uuid
            VDUUIDLabel.backgroundColor = getRandomColor()
        }
        
    }
    
    
    func getRandomColor() -> UIColor{
            let randomRed:CGFloat = CGFloat(drand48())
            let randomGreen:CGFloat = CGFloat(drand48())
            let randomBlue:CGFloat = CGFloat(drand48())
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        }

    
    @IBAction func touchUpPermissionBtn(_ sender: Any) {
        ATTrackingManager.requestTrackingAuthorization{ status in
            switch status {
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                break
            case .authorized:
                break
            default:
                break
            }
            
        }
        
    }
    
    
    
    
}

