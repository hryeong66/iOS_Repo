//
//  ViewController.swift
//  swimming-test-app-2
//
//  Created by 장혜령 on 2021/06/08.
//

import UIKit
import CSV

class ViewController: UIViewController {

    var swimmingList: [SwimWorkoutData] = []
    var swimmingDistanceDummy: [(String, String)] = []
    var swimmingStrokeDummy: [Int] = []
    var dataInText = SwimmingDateInText()
    
    var strokeDataList: [SwimmingStrokeData] = []
    var distanceDataList: [SwimmingDistanceData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDistanceDummyData()
        makeStrokeDumyData()
        dataInText.testDate()
       
        
        print(TimeZone.current.identifier)
    }
    
    func setNewCSVFile(fileName: String) -> URL{
        //fileManager 이용
        //core data 도 함께
        print(NSHomeDirectory())
        let fileManager = FileManager.default // 파일 매니저의 싱글톤 객체 리턴
        
        // document dir url
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print(documentsURL)
        
        let fileURL = documentsURL.appendingPathComponent(fileName)
        let myText = NSString(string:"")

        //빈파일로 다시 만들기
        try? myText.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)

        return fileURL
        
    }
    
    
    func getSwimmingDateInText(){
        distanceDataList = dataInText.refineSwimmingDistanceData(timeList: swimmingDistanceDummy)
        strokeDataList = dataInText.refineSwimmingStrokeData(timeList: swimmingDistanceDummy, strokeList: swimmingStrokeDummy)
    }
    
    @IBAction func getAuthorizationAtHealthKit(_ sender: Any) {
        authorizeHealthKit()
    }
    
    
    @IBAction func touchUpToGetSwimmingDistance(_ sender: Any) {
        getSwimmingDateInText()
        print(distanceDataList)
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print(strokeDataList)
    }
    
    //전체 수영 데이터 가져오기
    @IBAction func touchUpToGetSwimWorkoutData(_ sender: Any) {
        
        HealthDataStore.readSwimmingWorkout{ (result, error) in
            
            guard let swimmingData = result else {
                print("swimming 넘겨져온 데이터 없음")
                return
            }
        }
        
    }
    
    @IBAction func touchUpToStartWriter(_ sender: Any) {
        writeSwimmingData()
        writeSwimmingWorkoutData()
    }
    
    
    
    func getCSVWriter(){
        let stream = OutputStream(toFileAtPath: "file.csv", append: true)!
        let csv = try! CSVWriter(stream: stream)

        
        
        csv.stream.close()
    }
    
    
    func writeSwimmingData(){
        let documentURL = setNewCSVFile(fileName: "swimmingDetailData.csv")
        print("-----------------------")
        print(documentURL)
        print("-----------------------")
        
        let stream = OutputStream(url: documentURL , append: true)!
        let csv = try! CSVWriter(stream: stream)
        try! csv.write(row: ["시작시간", "종료시간", "운동시간" ,"랩길이", "style번호", "영법", "stroke"])
        
        for i in (0..<swimmingStrokeDummy.count).reversed(){
            var list:[String] = []
            
            list.append(contentsOf: distanceDataList[i].changeStringArray())
            list.append(contentsOf: strokeDataList[i].changeStringArray())
            
            try! csv.write(row: list)
        }

        csv.stream.close()
    }
    
    
    //귀찮아서 하드코딩
    func writeSwimmingWorkoutData(){
        let documentURL = setNewCSVFile(fileName: "swimmingWokoutData.csv")
        print("-----------------------")
        print(documentURL)
        print("-----------------------")
        
        let stream = OutputStream(url: documentURL , append: true)!
        let csv = try! CSVWriter(stream: stream)
        try! csv.write(row: ["시작시간",
                             "종료시간",
                             "운동시간" ,
                             "총거리",
                             "총칼로리(cal)",
                             "랩길이"])
        
        try! csv.write(row: ["2021-05-19 10:23:40 +0900",
                             "2021-05-19 10:45:42 +0900",
                             "1200.0" ,
                             "650m",
                             "151133.46260067655/cal",
                             "25m"])
        
        try! csv.write(row: ["2021-05-19 10:46:19 +0900",
                             "2021-05-19 10:56:05 +0900",
                             "500.0" ,
                             "200m",
                             "50307.05127620201/cal",
                             "25m"])
        
        csv.stream.close()
        
    }
    
    
}

// MARK: authorize
extension ViewController{
    private func authorizeHealthKit() {
      
      HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
        
        guard authorized else {
          
          let baseMessage = "HealthKit Authorization Failed"
          
          if let error = error {
            print("\(baseMessage). Reason: \(error.localizedDescription)")
          } else {
            print(baseMessage)
          }
          
          return
        }
        print("HealthKit Successfully Authorized.")
      }
      
    }

}

extension ViewController{
    func makeDistanceDummyData(){
        swimmingDistanceDummy.append(contentsOf: [
            
            //두번째 수영
            ("2021-05-19 01:55:22 +0000","2021-05-19 01:55:43 +0000"),
            ("2021-05-19 01:53:50 +0000","2021-05-19 01:54:06 +0000"),
            ("2021-05-19 01:53:02 +0000","2021-05-19 01:53:27 +0000"),
            ("2021-05-19 01:49:58 +0000","2021-05-19 01:50:22 +0000"),
            ("2021-05-19 01:49:35 +0000","2021-05-19 01:49:56 +0000"),
            
            ("2021-05-19 01:47:17 +0000","2021-05-19 01:47:42 +0000"),
            ("2021-05-19 01:46:47 +0000","2021-05-19 01:47:15 +0000"),
            ("2021-05-19 01:46:25 +0000","2021-05-19 01:46:45 +0000"),
            
            
            //첫번째 수영
            ("2021-05-19 01:44:06 +0000","2021-05-19 01:44:26 +0000"),
            ("2021-05-19 01:43:38 +0000","2021-05-19 01:44:03 +0000"),
            
            ("2021-05-19 01:42:08 +0000","2021-05-19 01:42:34 +0000"),
            ("2021-05-19 01:41:39 +0000","2021-05-19 01:42:03 +0000"),
            ("2021-05-19 01:40:12 +0000","2021-05-19 01:40:37 +0000"),
            ("2021-05-19 01:39:40 +0000","2021-05-19 01:40:04 +0000"),
            ("2021-05-19 01:39:13 +0000","2021-05-19 01:39:32 +0000"),
            
            ("2021-05-19 01:38:50 +0000","2021-05-19 01:39:09 +0000"),
            ("2021-05-19 01:36:52 +0000","2021-05-19 01:37:04 +0000"),
            ("2021-05-19 01:36:19 +0000","2021-05-19 01:36:40 +0000"),
            ("2021-05-19 01:35:11 +0000","2021-05-19 01:35:26 +0000"),
            ("2021-05-19 01:33:30 +0000","2021-05-19 01:33:54 +0000"),
            
            
            ("2021-05-19 01:32:57 +0000","2021-05-19 01:33:24 +0000"),
            ("2021-05-19 01:32:29 +0000","2021-05-19 01:32:54 +0000"),
            ("2021-05-19 01:31:58 +0000","2021-05-19 01:32:23 +0000"),
            ("2021-05-19 01:30:46 +0000","2021-05-19 01:31:14 +0000"),
            ("2021-05-19 01:30:28 +0000","2021-05-19 01:30:37 +0000"),
            
            
            ("2021-05-19 01:30:14 +0000","2021-05-19 01:30:28 +0000"),
            ("2021-05-19 01:29:48 +0000","2021-05-19 01:30:10 +0000"),
            ("2021-05-19 01:29:05 +0000","2021-05-19 01:29:16 +0000"),
            ("2021-05-19 01:28:47 +0000","2021-05-19 01:29:05 +0000"),
            ("2021-05-19 01:27:59 +0000","2021-05-19 01:28:24 +0000"),
            
            
            ("2021-05-19 01:27:38 +0000","2021-05-19 01:27:57 +0000"),
            ("2021-05-19 01:27:05 +0000","2021-05-19 01:27:33 +0000"),
            ("2021-05-19 01:26:39 +0000","2021-05-19 01:27:04 +0000"),
            ("2021-05-19 01:23:46 +0000","2021-05-19 01:23:53 +0000")
        ])
    }
    
    func makeStrokeDumyData(){
        swimmingStrokeDummy.append(contentsOf: [
            2,1,2,2,2, 2,2,2,5,5, 4,4,3,3,2,
            2,5,5,5,4, 4,4,4,3,3, 3,3,3,3,2, 2,2,2,4
        ])
    }
}
