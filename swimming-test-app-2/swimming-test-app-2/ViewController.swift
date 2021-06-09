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
    
    func setNewCSVFile() -> URL{
        //fileManager 이용
        //core data 도 함께

        print(NSHomeDirectory())
        let fileManager = FileManager.default // 파일 매니저의 싱글톤 객체 리턴
        
        // document dir url
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print(documentsURL)
        
        let fileURL = documentsURL.appendingPathComponent("healthData.csv")
        let myText = NSString(string:"")

        //빈파일로 다시 만들기
        try? myText.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)

        
        return fileURL
        
    }
    
    
    

    @IBAction func touchUpToStartWriter(_ sender: Any) {
     
        let documentURL = setNewCSVFile()
        
        print(documentURL)
        print("-----------------")
        
        let stream = OutputStream(url: documentURL , append: true)!
        let csv = try! CSVWriter(stream: stream)

        try! csv.write(row: ["id", "name"])
        try! csv.write(row: ["1", "foo"])
        try! csv.write(row: ["1", "bar"])

        csv.stream.close()
    }
    
    func getCSVWriter(){
        let stream = OutputStream(toFileAtPath: "file.csv", append: true)!
        let csv = try! CSVWriter(stream: stream)

        try! csv.write(row: ["id", "name"])
        try! csv.write(row: ["1", "foo"])
        try! csv.write(row: ["1", "bar"])

        csv.stream.close()
        
    }
    
    
}

