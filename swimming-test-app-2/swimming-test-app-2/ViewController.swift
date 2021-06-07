//
//  ViewController.swift
//  swimming-test-app-2
//
//  Created by 장혜령 on 2021/06/08.
//

import UIKit
import CSV

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func touchUpToStartWriter(_ sender: Any) {
        
        let stream = OutputStream(toFileAtPath: "file.csv", append: true)!
        let csv = try! CSVWriter(stream: stream)

        try! csv.write(row: ["id", "name"])
        try! csv.write(row: ["1", "foo"])
        try! csv.write(row: ["1", "bar"])

        csv.stream.close()
        
    }
    
}

