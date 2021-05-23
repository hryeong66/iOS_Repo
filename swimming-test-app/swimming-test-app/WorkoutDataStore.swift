//
//  WorkoutDataStore.swift
//  swimming-test-app
//
//  Created by 장혜령 on 2021/05/24.
//

import HealthKit

class WorkoutDataStore {
    static var sourceSet: Set<HKSource> = []
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

  
}
