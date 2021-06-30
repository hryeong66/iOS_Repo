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
    private var dateTextField = UITextField()
    private var calenderTextField = UITextField()
    private var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        createDatePickerWithWhellStyle()
        //self.preferredContentSize = CGSize(width: view.bounds.width, height: 250)
    }
    
    private func createDatePickerWithWhellStyle(){
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let doneButton = UIBarButtonItem(title: "확인", style: .done, target: nil, action: #selector(donePresseed))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        
    }
    
    private func createDatePickerWithCompactStyle(){
        
    }
    
    
    private func configureUI(){
        setAttributes()
        setConstraints()
    }

    private func setAttributes() {
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "ko")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.minuteInterval = 5
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        
        dateTextField.tintColor = .clear
        dateTextField.layer.cornerRadius = 5
        dateTextField.layer.borderWidth = 1
        dateTextField.layer.borderColor = UIColor.red.cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: dateTextField.frame.height))
        dateTextField.leftView = paddingView
        dateTextField.leftViewMode = .always
        
        dateTextField.text = "눌러서 시간을 입력해주세요"
    }
    
    private func setConstraints() {
        view.addSubview(dateTextField)
        dateTextField.snp.makeConstraints{make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(50)
        }
   }
   
    // MARK: - Selectors
    @objc
    private func handleDatePicker(_ sender: UIDatePicker) {
        print(sender.date)
    }
    
    @objc private func donePresseed(){
        dateTextField.text = getKoreaDateTime(date: datePicker.date)
        self.view.endEditing(true)
    }

    private func getKoreaDateTime(date: Date) -> String{
    
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
        return formatter.string(from: date)
    }
    
}
