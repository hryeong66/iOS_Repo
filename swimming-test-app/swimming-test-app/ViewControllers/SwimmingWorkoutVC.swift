//
//  StrokeVC.swift
//  swimming-test-app
//
//  Created by 장혜령 on 2021/05/24.
//

import UIKit

class SwimmingWorkoutVC: UIViewController {
    static let identifier = "SwimmingWorkoutVC"
    
    var swimmingList: [SwimWorkoutData] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        setDelegate()
        // Do any additional setup after loading the view.
    }
    

    private func registerXib(){
        let nibName = UINib(nibName: SwimmingTVC.identifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: SwimmingTVC.identifier)
    }
    
    private func setDelegate(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func touchUpToGetSwimmingWorkoutData(_ sender: Any) {
        WorkoutDataStore.readSwimmingWorkout{ (result, error) in
            
            guard let swimmingData = result else {
                print("swimming 넘겨져온 데이터 없음")
                return
            }
            
            DispatchQueue.main.async {
                self.swimmingList = swimmingData
                self.tableView.reloadData()
            }
            
        }
        
    }
    
}

extension SwimmingWorkoutVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swimmingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SwimmingTVC.identifier) as? SwimmingTVC else {
            return UITableViewCell()
        }
        
        cell.setContent(data: swimmingList[indexPath.row])
        return cell
    }
    
    
}
