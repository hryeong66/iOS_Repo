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
