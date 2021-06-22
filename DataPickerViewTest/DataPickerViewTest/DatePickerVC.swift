//
//  DatePickerVC.swift
//  DataPickerViewTest
//
//  Created by 장혜령 on 2021/06/22.
//

import UIKit

class DatePickerVC: UIViewController {

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
       datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
    }
    
    private func setConstraints() {
       view.addSubview(datePicker)
       datePicker.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
           datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
           datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
           datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
       ])
   }
   
// MARK: - Selectors
   @objc
   private func handleDatePicker(_ sender: UIDatePicker) {
       print(sender.date)
   }
   
}
