//
//  RunningTVC.swift
//  swimming-test-app
//
//  Created by 장혜령 on 2021/05/24.
//

import UIKit

class RunningTVC: UITableViewCell {

    static let identifier = "RunningTVC"
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(data: RunningData){
        self.startLabel.text = "시작시간 : \(data.startDate)"
        self.endLabel.text = "종료 시간 : \(data.endData)"
        self.distanceLabel.text = "\(data.distance) m"
    }
    
}
