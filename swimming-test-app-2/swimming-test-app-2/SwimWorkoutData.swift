//
//  SwimWorkoutData.swift
//  swimming-test-app
//
//  Created by 장혜령 on 2021/05/24.
//

import Foundation
import HealthKit

struct SwimWorkoutData {
    var startDate: String
    var endDate: String
    var duration : Double
    var totalDistance : Double
    var totalEnergyBured : Double
    var workourActivityType: HKWorkoutActivityType
    var totalSwimmingStrokeCount: Double
    var metadata: [String : Any]
    
    func display(){
        print("---------------------------")
        print("startDate =  \(startDate)")
        print("endDate =  \(endDate)")
        print("duration =  \(duration)")
        print("totalDistance =  \(totalDistance)")
        print("totalEnergyBured =  \(totalEnergyBured)")
        print("workourActivityType =  \(workourActivityType)")
        print("totalSwimmingStrokeCount =  \(totalSwimmingStrokeCount)")
        print("metadata =  \(metadata)")
        print("---------------------------")
    }
}

struct SwimmingDistanceData {
    var startDate: String = ""
    var endDate: String = ""
    var useTime: Int = 0
    var labLength: String = "25"
    
    func changeStringArray() -> [String]{
        return [startDate, endDate, useTime.description, "\(labLength)m"]
    }
}


struct SwimmingStrokeData{
    var startDate: String = ""
    var endDate: String = ""
    var count: Int = 0
    var strokeStyle: Int = 0
    var storkeStyleENG:String = ""
    var strokeStyleKR:String = ""

    func changeStringArray() -> [String] {
        return [strokeStyle.description, strokeStyleKR, storkeStyleENG]
    }
    
}
