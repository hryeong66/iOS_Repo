//
//  DatePickerVC.swift
//  UIDatePickerTest
//
//  Created by 장혜령 on 2021/06/22.
//

import UIKit
import SnapKit
class DatePickerVC: UIViewController {

    static let identifier = "DatePickerVC"
    private var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI(){
        setAttributes()
        setConstraints()
    }

    private func setAttributes() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.minuteInterval = 5
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
    }
    
    private func setConstraints() {
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints{make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
   }
   
// MARK: - Selectors
   @objc
   private func handleDatePicker(_ sender: UIDatePicker) {
       print(sender.date)
   }
   
}
