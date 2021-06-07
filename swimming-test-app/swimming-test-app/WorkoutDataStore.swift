//
//  WorkoutDataStore.swift
//  swimming-test-app
//
//  Created by 장혜령 on 2021/05/24.
//

import HealthKit

class WorkoutDataStore {
    
    static let healthStore = HKHealthStore()
    static var sourceSet: Set<HKSource> = []
    
    
    
    class func loadRunningWorkouts(completion:
                                    @escaping ([HKWorkout]?, Error?) -> Void) {
        
        loadAvailableSource()
        print(sourceSet)
        print("---------------------")
        //1. Get all workouts with the "Other" activity type.
        let workoutData = HKQuery.predicateForWorkouts(with: .running)
        
        //2. Get all workouts that only came from this app.
        //소스 쿼리를 통해서 모든 소스 넣어보기
        let sourcePredicate = HKQuery.predicateForObjects(from: sourceSet)
        
        
        //3. Combine the predicates into a single predicate.
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:
                                            [workoutData, sourcePredicate])
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                              ascending: true)
        
        
        let query = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: compound,
            limit: 0,
            sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            DispatchQueue.main.async {
                //4. Cast the samples as HKWorkout
                guard
                    let samples = samples as? [HKWorkout],
                    error == nil
                else {
                    completion(nil, error)
                    return
                }
                
                completion(samples, nil)
            }
        }
        
        HKHealthStore().execute(query)
    }
    
    
    func creatAndSaveRunningSample(){
        //Start by creating quantity objects for the total energy burned, and total distance traveled.
        var myIntervals = [ Date(), Date()]
        
        let energyBurned = HKQuantity(unit: HKUnit.largeCalorie(), doubleValue: 425.0)
        let distance = HKQuantity(unit: HKUnit.meter(), doubleValue: 100)
        
        
        //Next create the workout sample.
        let run = HKWorkout(activityType: HKWorkoutActivityType.running,
                            start: Date(),
                            end: Date(),
                            duration: 0,
                            totalEnergyBurned: energyBurned,
                            totalDistance: distance,
                            metadata: nil)
        
        
        HKHealthStore().save(run) { (success, error) -> Void in
            guard success else {
                // Perform proper error handling here.
                print("에러발생")
                return
            }
            
            
            // Add detail samples here.
            guard let distanceType =
                    HKObjectType.quantityType(forIdentifier:
                                                HKQuantityTypeIdentifier.distanceWalkingRunning) else {
                fatalError("*** Unable to create a distance type ***")
            }
            
            let distancePerInterval = HKQuantity(unit: HKUnit.foot(),
                                                 doubleValue: 165.0)
            
            let distancePerIntervalSample = HKQuantitySample(type: distanceType,
                                                             quantity: distancePerInterval,
                                                             start: myIntervals[0],
                                                             end: myIntervals[1])
            
        }
        
    }
    
    static func readAssociatedSamples(completion:
                                        @escaping ([HKQuantitySample]?, Error?) -> Void){
        
        guard let distanceType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning) else {
            fatalError("*** Unable to create a distance type ***")
        }
        
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
        
        let startDateSort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        
        let query = HKSampleQuery(sampleType: distanceType,
                                  predicate: workoutPredicate,
                                  limit: 0,
                                  sortDescriptors: [startDateSort]) { (sampleQuery, results, error) -> Void in
            guard let distanceSamples = results as? [HKQuantitySample] else {
                // Perform proper error handling here.
                print("HKSampleQuery 에러남")
                print(error)
                completion(nil, error)
                return
            }
            
            completion(distanceSamples, nil)
            
            // Use the workout's distance samples here.
        }
        
        HKHealthStore().execute(query)
        
    }
    
    
    static func readWorkoutType(completion:
                                    @escaping ([HKSample]?, Error?) -> Void){
        let sampleType = HKObjectType.workoutType()
        let startDateSort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: nil,
                                  limit: 0,
                                  sortDescriptors: [startDateSort]){ (sampleQuery, results, error) -> Void in
            
            guard let resultList = results else{
                print(error)
                completion(nil, error)
                return
            }
            completion(resultList, nil)
        }
        
        HKHealthStore().execute(query)
    }
    
    
    
}

// MARK: read sources
extension WorkoutDataStore {
    static func loadHealthKitSource(completion: @escaping (Set<HKSource>?) -> Void ){
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .distanceSwimming) else {
            fatalError("*** Unable to get the step count type ***")
        }
        print("sample type 가져옴")
        print(sampleType)
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let query = HKSourceQuery(sampleType: sampleType,
                                  samplePredicate: predicate){ (query, result, error) in
            guard let samples = result else{
                print("results로 넘겨져 오는게 없음")
                completion(nil)
                return
            }
            
            
            for source in samples{
                print(source)
                print("----------")
                sourceSet.insert(source)
            }
            print(samples.count)
            
            completion(samples)
        }
        
        healthStore.execute(query)
    }
    
    class func loadAvailableSource(){
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .height) else {
            fatalError("*** Unable to get the step count type ***")
        }
        
        print("sample type 가져옴")
        print(sampleType)
        let query = HKSourceQuery(sampleType: sampleType, samplePredicate: nil) { (query, sourcesOrNil, errorOrNil) in
            print("HKSourceQuery 클로저")
            guard let sources = sourcesOrNil else {
                print("sources가 아무것도 없나??")
                return
            }
            
            print(sources)
            print("-----가져온 source----")
            
            for source in sources {
                sourceSet.insert(source)
                print(source)
            }
            
            print("source 다 가져옴")
            
            DispatchQueue.main.async {
                // Update the UI here.
            }
        }
        HKHealthStore().execute(query)
    }
    
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


// MARK: walking and running data
extension WorkoutDataStore{
    static func readHeartBitRate(completion: @escaping ([HKSample]? , Error?) -> Void){
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .walkingSpeed) else {
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: predicate,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]){(sample, result, error) in
            guard let resultList = result else{
                print("result is nil")
                completion(nil, error)
                return
            }
            
            completion(result, nil)
        }
        healthStore.execute(query)
        
    }
    
    static func readDistanceWalkingRunning(completion: @escaping ([RunningData]?, Error?) -> Void){
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else{
            return
        }
        let startDate = Calendar.current.date(byAdding: .month,
                                              value: -1,
                                              to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: predicate,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]) {(query, reault, error) in
            guard let sampleList = reault else{
                print("sample data 안넘어옴")
                completion(nil, error)
                return
            }
            
            var walkingQuantitySamples: [RunningData] = []
            for sample in sampleList {
                let start = sample.startDate.description
                let end = sample.endDate.description
                
                let src = sample as! HKQuantitySample
                let meterUnit = HKUnit.meter()
                
                var distance = src.quantity.doubleValue(for: meterUnit)
                distance = floor(distance * 1000)/1000
                walkingQuantitySamples.append(RunningData(startDate: start, endData: end, distance: distance))
            }
            
            completion(walkingQuantitySamples, nil)
        }
        healthStore.execute(query)
    }
    
    static func readRunningWorkout(completion: @escaping ([HKSample]?, Error?) -> Void ){
        let sampleType = HKObjectType.workoutType()
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let runningPredicate = HKQuery.predicateForWorkouts(with: .walking)
        let sourcePredicate = HKQuery.predicateForObjects(from: sourceSet)
        
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
                var src = sample as! HKWorkout
                print(src.duration)
                print(src.totalDistance)
                print(src.totalEnergyBurned)
                print(src.workoutActivityType)
                print("---------------------")
            }
            completion(samples, nil)
        }
        
        healthStore.execute(query)
    }
    
    
}



// MARK: Swimming Data
extension WorkoutDataStore {
    //completion: @escaping
    static func readSwimmingDistance(completion: @escaping ([SwimmingData]?, Error?) -> Void){
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .distanceSwimming) else{return}
        let startDate = Calendar.current.date(byAdding: .month,
                                              value: -1,
                                              to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        var swimmingList: [SwimmingData] = []
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: predicate,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]) {(query, result, error) in
            guard let samples = result else{
                print("수영데이터 안넘어 옴")
                completion(nil, error)
                return
            }
            
            for sample in samples {
                let start = sample.startDate.description
                let end = sample.endDate.description
                
                let src = sample as! HKQuantitySample
                let meterUnit = HKUnit.meter()
                
                var distance = src.quantity.doubleValue(for: meterUnit)
                distance = floor(distance * 1000)/1000
                
                swimmingList.append(SwimmingData(startDate: start, endData: end, distance: distance))
                
            }
            completion(swimmingList, nil)
        }
        healthStore.execute(query)
    }
    
    static func readSwimmingWorkout(completion: @escaping ([SwimWorkoutData]?, Error?) -> Void ){
        let sampleType = HKObjectType.workoutType()
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
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
    
    
}
