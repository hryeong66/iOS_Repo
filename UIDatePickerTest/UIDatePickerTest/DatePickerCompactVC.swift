//
//  DatePickerCompactVC.swift
//  UIDatePickerTest
//
//  Created by 장혜령 on 2021/06/24.
//

import UIKit
import SnapKit

class DatePickerCompactVC: UIViewController {

    static let identifier = "DatePickerCompactVC"
    
    private var datePicker = UIDatePicker()
    private var dateTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    
    private func configureUI(){
        setAttributes()
        setConstraints()
    
    }
    

    private func setAttributes(){
        datePicker.preferredDatePickerStyle = .compact
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "ko")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.minuteInterval = 5
        datePicker.minimumDate = Date()
        
    }
    
    private func setConstraints(){
        //view.addSubview(datePicker)
        view.addSubview(dateTextField)
//        datePicker.snp.makeConstraints{make in
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
//        }
        
        
        dateTextField.snp.makeConstraints{make in
           make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
           make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        dateTextField.backgroundColor = .lightGray
        
    }
    
    //textfield 눌렸을 때,
    

}

