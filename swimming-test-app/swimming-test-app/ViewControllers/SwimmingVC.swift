//
//  HealthKitTestVC.swift
//  swimming-test-app
//
//  Created by 장혜령 on 2021/05/24.
//

import UIKit

class SwimmingVC: UIViewController {
    static let identifier = "SwimmingVC"
    
    var swimmingList: [SwimmingData] = []
    
    @IBOutlet weak var swimTableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        setDelegate()
        // Do any additional setup after loading the view.
    }
    private func registerXib(){
        let nibName = UINib(nibName: RunningTVC.identifier, bundle: nil)
        swimTableView.register(nibName, forCellReuseIdentifier: RunningTVC.identifier)
    }
    
    private func setDelegate(){
        swimTableView.delegate = self
        swimTableView.dataSource = self
    }
    
    @IBAction func touchUpToGetSwimmingData(_ sender: Any) {
        
        WorkoutDataStore.readSwimmingDistance{(result, error) in
            guard let simmingDatas = result else{
                print("넘어온 수영 데이터가 없음")
                return
            }
            
            DispatchQueue.main.async {
                self.swimmingList = simmingDatas
                self.swimTableView.reloadData()
            }

        }
        
    }
    
    @IBAction func touchUpToGetStorkeData(_ sender: Any) {
        guard let nextVC = storyboard?.instantiateInitialViewController() else {return}
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}


extension SwimmingVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swimmingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: RunningTVC.identifier) as? RunningTVC else {
            return UITableViewCell()
        }
        
        let swimData = swimmingList[indexPath.row]
        
        cell.setContent(data: RunningData(startDate: swimData.startDate, endData: swimData.endData, distance: swimData.distance))
        
        return cell
        
    }
    
    
}
