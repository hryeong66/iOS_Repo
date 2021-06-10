//
//  ViewController.swift
//  swimming-test-app
//
//  Created by 장혜령 on 2021/05/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var runningLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        runningLabel.numberOfLines = 0
    }
    
    @IBAction func pushToRunningView(_ sender: Any) {
        guard let nextVC = storyboard?.instantiateViewController(identifier: WalkingRunningVC.identifier) else{return}
         
        self.navigationController?.pushViewController(nextVC , animated: true)
    }
    
    @IBAction func pushToSwimmingView(_ sender: Any) {
        guard let nextVC = storyboard?.instantiateViewController(identifier: SwimmingWorkoutVC.identifier) else{return}
         
        self.navigationController?.pushViewController(nextVC , animated: true)
    }
    
    
    @IBAction func touchUpToAuthorizeHealthKit(_ sender: Any) {
        authorizeHealthKit()
    }
    
    @IBAction func touchUpToGetRunningData(_ sender: Any) {
        print("touchUpToGetRunningData")
        WorkoutDataStore.loadRunningWorkouts{ (workouts, error) in
            print("loadRunningWorkouts 클로져 안")
            guard let workoutList = workouts else { return print("return nil")}
            
            
            var content = ""
            for workout in workoutList{
                var distant = workout.totalDistance?.doubleValue(for: .meter())
                var workoutType = workout.workoutActivityType
                content += "distant = \(distant), type = \(workoutType)"
                print(content)
            }
            self.runningLabel.text = content
            
//            DispatchQueue.main.async {
//                // Update the UI here.
//            }
        }
    }
    
    
    @IBAction func touchUpToGetDistanceSample(_ sender: Any) {
        WorkoutDataStore.readAssociatedSamples { (samples, errer) in
            guard let sampleList = samples else {
                return
            }
            var contents = ""
            for sample in sampleList{
                contents += "quantity = \(sample.quantity)\n"
                contents += "quantityType = \(sample.quantityType)\n"
                contents += "-----------------------------------"
            }
            
            print(contents)
        }
        
    }
    
    
    @IBAction func touchUpToGetAllWorkout(_ sender: Any) {
        print("touchUpToGetAllWorkout")
        WorkoutDataStore.readWorkoutType{ (samples, error) in
            
            if samples == nil{
                print("samples is nil")
            }
            
            print("samples is not nil")
            
            guard let sampleList = samples else{
                print("samplelist == nil")
                return
            }
            
            print(sampleList.count)
            for sample in sampleList{
                print("-------------")
                print(sample)
                print("~~~~~~~~")
            }
            
        }
    }
    
    
    @IBAction func touchUpToGetHeartRate(_ sender: Any) {
        WorkoutDataStore.readHeartBitRate{ (samples, errer) in
            guard let results = samples else {
                print("넘겨져온 sample nil")
                return
            }
            
            print(results.count)
            for sample in results {
                print(sample)
                print("~~~~~~~~")
            }
        }
    }
    
    
    @IBAction func touchUpToGetSources(_ sender: Any) {
//        WorkoutDataStore.loadHealthKitSource{(sources) in
//            guard let healthSources = sources else{
//                print("nil 넘어옴")
//                return
//            }
//            for src in healthSources{
//                print(src.name)
//                print(src.bundleIdentifier)
//            }
//        }
        
        WorkoutDataStore.loadWorkoutHKSource()
    }
    
    
    @IBAction func touchUpToGetRunningWorkoutData(_ sender: Any) {
        
        WorkoutDataStore.readRunningWorkout{(result, error) in
            guard let samples = result else {
                print("넘어온 sample이 없음")
                return
            }
            print("sample 갯수 \(samples.count)")
            
            for sample in samples{
                print(sample.startDate)
                print(sample.endDate)
            }
            
        }
    }
    
    @IBAction func touchUpToGetSwimmingWorkoutData(_ sender: Any) {
        WorkoutDataStore.readSwimmingWorkout{(result, errer) in
            guard let samples = result else {
                print("넘겨져온 값 없음")
                return
            }
            print("메인에서 \(samples.count)")
            
            for sample in samples{
                print(sample.startDate)
                print(sample.endDate)
            }
            
        }
        
    }
    
    
    
}


// MARK: authorizw
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

