//
//  ViewController.swift
//  UIDatePickerTest
//
//  Created by 장혜령 on 2021/06/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clickToPresentModal(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: DatePickerVC.identifier) else {
            return
        }
        
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
    
}

