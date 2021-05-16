//
//  ViewController.swift
//  HealthKit_test
//
//  Created by 장혜령 on 2021/04/12.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad(){
        super.viewDidLoad()
        titleLabel.numberOfLines = 0
        // Do any additional setup after loading the view.
    }

    @IBAction func touchUpCheckHealthKit(_ sender: Any) {
        if HKHealthStore.isHealthDataAvailable(){
            titleLabel.text = "HealthKit 사용 가능"
        }else{
            titleLabel.text = "HealthKit 사용 불가능"
            titleLabel.textColor = .red
        }
    }
    
    func setHealthKitStore(){
        let healthStore = HKHealthStore()
    }
    
}

