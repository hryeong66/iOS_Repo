//
//  SwimmingTVC.swift
//  swimming-test-app
//
//  Created by 장혜령 on 2021/05/24.
//

import UIKit

class SwimmingTVC: UITableViewCell {

    static let identifier = "SwimmingTVC"
    @IBOutlet weak var startLabel: UILabel!
    
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var totalEnergyBuredLabel: UILabel!
    @IBOutlet weak var workourActivityTypeLabel: UILabel!
    @IBOutlet weak var totalSwimmingStrokeCountLabel: UILabel!
    @IBOutlet weak var metadataLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(data: SwimWorkoutData){
        startLabel.text = "시작 : \(data.startDate)"
        endLabel.text = "끝 : \(data.endDate)"
        durationLabel.text = "기간 : \(data.duration)"
        totalDistanceLabel.text = "전체 거리 : \(data.totalDistance)"
        totalEnergyBuredLabel.text = "전체 활동에너지 \(data.totalEnergyBured)"
        workourActivityTypeLabel.text = "현재 운동 \(data.workourActivityType)"
        totalSwimmingStrokeCountLabel.text = "스트로크 개수 \(data.totalSwimmingStrokeCount)"
        metadataLabel.numberOfLines = 0
        metadataLabel.text = "metadata\n \(data.metadata)"
        
    }
    
}


/*
 var startDate: String
 var endDate: String
 var duration : Double
 var totalDistance : Double
 var totalEnergyBured : Double
 var workourActivityType: HKWorkoutActivityType
 var totalSwimmingStrokeCount: Double
 var metadata: [String : Any]
 
 */
