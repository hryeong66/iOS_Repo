//
//  HealthKitSetupAssistant.swift
//  swimming-test-app
//
//  Created by 장혜령 on 2021/05/23.
//

import Foundation

import HealthKit

class HealthKitSetupAssistant {
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    static func authorizeHealthKitAtSwimming(completion: @escaping (Bool, Error?) -> Void){
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
                let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
                let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
                let basalEnergy = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned),
                let swimStroke = HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount),
                let distanceSwimming = HKObjectType.quantityType(forIdentifier: .distanceSwimming),
                let exerciseTime = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
        else {
            //let workout = HKObjectType.workoutType()
            
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
        }
        
        //3. Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = [activeEnergy,
                                                        HKObjectType.workoutType()]
        
        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                       biologicalSex,
                                                       activeEnergy,
                                                       swimStroke,
                                                       distanceSwimming,
                                                       exerciseTime,
                                                       HKObjectType.workoutType()]
        
        //4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        
        //1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        //2. Prepare the data types that will interact with HealthKit
        guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
                let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
                let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
                let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
                let swimStroke = HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount),
                let distanceSwim = HKObjectType.quantityType(forIdentifier: .distanceSwimming),
                let distanceRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
                let walkingSpeed = HKObjectType.quantityType(forIdentifier: .walkingSpeed)
        else {
            //let workout = HKObjectType.workoutType()
            
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
        }
        
        //3. Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = [activeEnergy,
                                                        HKObjectType.workoutType()]
        
        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                       biologicalSex,
                                                       bodyMass,
                                                       activeEnergy,
                                                       swimStroke,
                                                       distanceSwim,
                                                       distanceRunning,
                                                       walkingSpeed,
                                                       HKObjectType.workoutType()]
        
        //4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    
    
    
}
