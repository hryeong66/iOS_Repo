//
//  HealthDataStore.swift
//  swimming-test-app-2
//
//  Created by 장혜령 on 2021/06/10.
//

import Foundation
import HealthKit

class HealthDataStore{
    
    static let healthStore = HKHealthStore()
    static var sourceSet: Set<HKSource> = []

   
    static let startDate = Calendar.current.date(byAdding: .month,
                                          value: -1,
                                          to: Date())
    
    static let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
    
    
    static func loadWorkoutHKSource() {
        let sampleType = HKObjectType.workoutType()
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sourceQuery = HKSourceQuery.init(sampleType: sampleType,
                                             samplePredicate: predicate){(query, result, error) in
            guard let sources = result else{
                print("source nil")
                return
            }
            
            print("source 가져와졌음 \(sources.count)")
            
            sourceSet.removeAll()
            for src in sources {
                print(src.name)
                print(src.bundleIdentifier)
                sourceSet.insert(src)
            }
            print(query)
        }
        healthStore.execute(sourceQuery)
    }
    
}






//MARK: Swimming
extension HealthDataStore{
    
    //수영 전체 workoutData
    static func readSwimmingWorkout(completion: @escaping ([SwimWorkoutData]?, Error?) -> Void ){
        let sampleType = HKObjectType.workoutType()
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let swimmingPredicate = HKQuery.predicateForWorkouts(with: .swimming)
        let sourcePredicate = HKQuery.predicateForObjects(from: sourceSet)
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [swimmingPredicate, sourcePredicate])
        
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: compound,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]){(query, result, error) in
            guard let samples = result else {
                print("workout으로 넘어져 오는게 없음")
                completion(nil, error)
                return
            }
            print(samples.count)
            var swimmingWorkoutList: [SwimWorkoutData] = []
            for sample in samples{
                let start = sample.startDate.description
                let end = sample.endDate.description
                
                let src = sample as! HKWorkout
                var duration = src.duration
                duration = floor(duration / 100) * 100
                
                let meterUnit = HKUnit.meter()
                var totalDistance = src.totalDistance?.doubleValue(for: meterUnit) ?? 1
                //totalDistance = floor(totalDistance/1000) * 1000
                
                
                let smallCalorie = HKUnit.smallCalorie()
                var totalEnergy = src.totalEnergyBurned?.doubleValue(for: smallCalorie) ?? 0
                
                let workoutType = src.workoutActivityType
                var strokes = src.totalSwimmingStrokeCount?.doubleValue(for: HKUnit.count()) ?? 0
                let metaData = src.metadata ?? [:]
                
                let swimming = SwimWorkoutData(startDate: start,
                                           endDate: end,
                                           duration: duration,
                                           totalDistance: totalDistance,
                                           totalEnergyBured: totalEnergy,
                                           workourActivityType: workoutType,
                                           totalSwimmingStrokeCount: strokes,
                                           metadata: metaData)
                
                
                swimmingWorkoutList.append(swimming)
                swimming.display()
                
            }
            completion(swimmingWorkoutList, nil)
            
        }
        healthStore.execute(query)
    }
    
    static func getAllSwimmingDistance(completion: @escaping ([SwimmingDistanceData]?, Error?) -> Void){
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .distanceSwimming) else{
            return
        }

        let datePredicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictEndDate)
        
        let strokeStylePredicate = HKQuery.predicateForObjects(withMetadataKey: HKMetadataKeySwimmingStrokeStyle)
        
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: datePredicate,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]) {(query, reault, error) in
            guard let sampleList = reault else{
                print("sample data 안넘어옴")
                completion(nil, error)
                return
            }
            
            let distanceList = refineSwimmingDistanceData(samples: sampleList)
            completion(distanceList, nil)
        }
        healthStore.execute(query)
    }
    
    static func getAllStrokeDistance(completion: @escaping ([HKSample]?, Error?) -> Void){
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount) else{
            return
        }

        let datePredicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictEndDate)
        
        let strokeStylePredicate = HKQuery.predicateForObjects(withMetadataKey: HKMetadataKeySwimmingStrokeStyle)
        
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: datePredicate,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]) {(query, reault, error) in
            guard let sampleList = reault else{
                print("sample data 안넘어옴")
                completion(nil, error)
                return
            }

            
            completion(sampleList, nil)
        }
        healthStore.execute(query)
    }
    

    
}

//MARK: Data 처리
extension HealthDataStore{
    static func refineSwimmingDistanceData(samples: [HKSample]) -> [SwimmingDistanceData]{
        //시작시간, 종료시간 , 운동시간, 거리
        var list: [SwimmingDistanceData] = []

        for src in samples{
            let timeDate = refineDateData(start: src.startDate, end: src.endDate)
            let tmp = SwimmingDistanceData()
            list.append(tmp)
        }
        return list
    }

    static func refineSwimmingStrokeData(samples: [HKSample]) -> [SwimmingStrokeData]{
        //시작시간, 종료시간, 스트로크 종류
        var list: [SwimmingStrokeData] = []
        for src in samples{
            let timeDate = refineDateData(start: src.startDate, end: src.endDate)
            
            let tmp = SwimmingStrokeData()

//                if let quantitySample = sample as? HKQuantitySample {
//                    let strokes = quantitySample.quantity.doubleValue(for: HKUnit.count())
//                    print(strokes)
//                }
//
//                if let strokeStyleInt = sample.metadata?["HKSwimmingStrokeStyle"] as? Int,
//                   let strokeStyle = HKSwimmingStrokeStyle(rawValue: strokeStyleInt){
//                    print(strokeStyle)
//                }


        }
        return list
    }

    static func refineDateData(start: Date, end: Date) -> [String]{
        //데이터형식 2019-09-17 13:40:00
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko")
        let useTime = Int(end.timeIntervalSince(start))
        format.dateFormat = "HH:mm"
        let startTime = format.string(from: start)
        let endTime = format.string(from: end)
        return [startTime, endTime, useTime.description]
    }

}





//MARK: Running
extension HealthDataStore {
    static func readRunningWorkout(completion: @escaping ([HKSample]?, Error?) -> Void ){
        let sampleType = HKObjectType.workoutType()
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let runningPredicate = HKQuery.predicateForWorkouts(with: .walking)
        let sourcePredicate = HKQuery.predicateForObjects(from: sourceSet)
        let speedPredicate = HKQuery.predicateForObjects(withMetadataKey: HKMetadataKeyAverageSpeed)
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [runningPredicate, sourcePredicate])
        
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: compound,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]){(query, result, error) in
            guard let samples = result else {
                print("workout으로 넘어져 오는게 없음")
                completion(nil, error)
                return
            }
            print(samples.count)
            
            for sample in samples{
                print(sample.startDate)
                print(sample.endDate)
                var src = sample as! HKWorkout
                print(src.duration)
                print(src.totalDistance)
                print(src.totalEnergyBurned)
                print(src.workoutActivityType)
                print(src.metadata)
                dump(src)
                print("---------------------")
            }
            completion(samples, nil)
        }
        healthStore.execute(query)
    }
    
    static func makeRunningWorkoutData(){
        let energyBurned = HKQuantity(unit: HKUnit.largeCalorie(), doubleValue: 425.0)
        let distance = HKQuantity(unit: HKUnit.mile(), doubleValue: 3.2)
        
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        let run = HKWorkout(activityType: .running, start: startDate, end: Date(), duration: 0, totalEnergyBurned: energyBurned, totalDistance: distance, metadata: nil)
    }
    
    static func makeRunningSamples(){
        let sampleType = HKObjectType.workoutType()
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let swimmingPredicate = HKQuery.predicateForWorkouts(with: .swimming)
        let sourcePredicate = HKQuery.predicateForObjects(from: sourceSet)
        let swimmingStrokePredicate = HKQuery.predicateForObjects(withMetadataKey: HKMetadataKeySwimmingStrokeStyle)
        
    }

}
