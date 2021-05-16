//
//  ViewController.swift
//  Test-Charts-Library
//
//  Created by 장혜령 on 2021/05/16.
//

import UIKit
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    var numbers: [Double] = [3.0, 2.5, 3.3, 5.5, 2.7, 1.0, 4.2]
    let dayOfWeek: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLineChartdata()
        // Do any additional setup after loading the view.
    }

    
    func changeLineChartdata(){
        var lineChartEntry = [ChartDataEntry]() // graph 에 보여줄 data array
         // chart data array 에 데이터 추가
         for i in 0..<numbers.count {
                let value = ChartDataEntry(x: Double(i), y: numbers[i])
                lineChartEntry.append(value)
         }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "수영거리")
        line1.colors = [NSUIColor.systemTeal]
        line1.circleColors = [NSUIColor.lightGray]
        line1.circleHoleColor = NSUIColor.systemTeal
        print("line1.circleRadius = \(line1.circleRadius)")
        line1.circleRadius = 5.0
        line1.circleHoleRadius = 2.0
        print("line1.lineWidth = \(line1.lineWidth)")
        line1.lineWidth = 3.0
        
        
        line1.mode = .cubicBezier
        
        let data = LineChartData(dataSet: line1)
            
        lineChartView.data = data
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dayOfWeek)
        lineChartView.xAxis.setLabelCount(dayOfWeek.count, force: true)
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        
    }
    @IBAction func startAnimation(_ sender: Any) {
        lineChartView.animate(yAxisDuration: 2.0, easingOption: .easeInOutQuint)
    }
    
}

