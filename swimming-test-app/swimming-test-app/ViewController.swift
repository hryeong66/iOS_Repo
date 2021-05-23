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

