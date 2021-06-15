//
//  SwimmingDataInText.swift
//  swimming-test-app-2
//
//  Created by 장혜령 on 2021/06/14.
//

import Foundation

class SwimmingDateInText{
    init() {
        
    }
    /*
     * 수영 distance 처리 in dummy
     */
    func refineSwimmingDistanceData(timeList: [(String, String)]) -> [SwimmingDistanceData]{
        //시작시간, 종료시간 , 운동시간, 거리
        var list: [SwimmingDistanceData] = []
        
        for i in 0..<timeList.count{
            print(i)
            let start = changeStringTolocalTime(timeList[i].0)
            let end = changeStringTolocalTime(timeList[i].1)
            let timeDate = refineDateData(start: start, end: end)
            let tmp = SwimmingDistanceData(startDate: start, endDate: end, useTime: timeDate)
            list.append(tmp)
        }
        return list
    }
    
    private func refineDateData(start: String, end: String ) -> Int{
        //데이터형식 2019-09-17 13:40:00
        
        let startDate = changeStringToDate(start)
        let endDate = changeStringToDate(end)
        let useTime = Int(endDate.timeIntervalSince(startDate))
        return useTime
    }
    
    
    func changeStringToDate(_ str: String) -> Date{

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")
        
        
        if let date = formatter.date(from: str){
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            return date
        }
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.locale = Locale(identifier: "ko_KR")
//        let date = dateFormatter.date(from: str)
//        print( "정제된 시간 : \(dateFormatter.string(from: date!))")
//
        return Date()
    }
    
    func changeStringTolocalTime(_ str: String) -> String{
        print("original date = \(str)")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")
        
        if let date = formatter.date(from: str){
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            let localTime = formatter.string(from: date)
            print(localTime)
            return localTime
        }
        return "\(str)"
    }
    
    
    
    
    func testDate(){
        
        let dateString = "\(Date())"
        print("original date = \(dateString)")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")

        if let date = formatter.date(from: dateString) {
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            let localTime = formatter.string(from: date)
            print(localTime)
        }
        print("test")
        
        print("----------------------")
        let current = "\(Date())"
        print("row 현재시간 : \(current)")
        //print("넣은 시간 : \(str)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let refined_cur = dateFormatter.date(from: current)
        print(refined_cur)
        print("정제한 후 현재시간 \(refined_cur!)")
    }
    

    
    
    /*e
     * 수영 stroke 처리 in dummy
     */
    func refineSwimmingStrokeData(timeList: [(String,String)], strokeList: [Int]) -> [SwimmingStrokeData]{
        //시작시간, 종료시간, 스트로크 종류
        var list: [SwimmingStrokeData] = []
        for i in 0..<strokeList.count{
            let start = changeStringTolocalTime(timeList[i].0)
            let end = changeStringTolocalTime(timeList[i].1)
            let timeDate = refineDateData(start: start, end: end)
            var tmp = SwimmingStrokeData(startDate: start, endDate: end)
            let strokeStyle = changeStrokeString(styleNumber: strokeList[i])
            tmp.strokeStyle = strokeList[i]
            tmp.storkeStyleENG = strokeStyle.0
            tmp.strokeStyleKR = strokeStyle.1
            list.append(tmp)
        }
        
        return list
    }
    
    
    func changeStrokeString(styleNumber: Int) -> (String, String){
        switch styleNumber {
        case 1:
            return("mixed", "혼합영")
        case 2:
            return("freestyle", "자유영")
        case 3:
            return("backstroke", "배영")
        case 4:
            return("breaststroke", "평영")
        case 5:
            return("butterfly", "접영")
        default:
            return("unknown", "확인불가")
        }
    }
    
}
