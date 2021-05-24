//
//  WalkingRunningVC.swift
//  swimming-test-app
//
//  Created by 장혜령 on 2021/05/24.
//

import UIKit
import HealthKit

class WalkingRunningVC: UIViewController {
    static let identifier = "WalkingRunningVC"
    var sampleList : [RunningData] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        setDelegate()
        // Do any additional setup after loading the view.
    }
    
    private func registerXib(){
        let nibName = UINib(nibName: RunningTVC.identifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: RunningTVC.identifier)
    }
    
    private func setDelegate(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func touchUpToGetWalkingData(_ sender: Any) {
        
        WorkoutDataStore.readDistanceWalkingRunning{(result, error) in
            guard let runningData = result else{
                print("넘겨져온 데이터가 없음 ")
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.sampleList = runningData
                self.tableView.reloadData()
            }
            
        }
    }
    
    
}

extension WalkingRunningVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
extension WalkingRunningVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RunningTVC.identifier) as? RunningTVC else{
            return UITableViewCell()
        }
        
        cell.setContent(data: sampleList[indexPath.row])
        
        return cell
    }
    
}
