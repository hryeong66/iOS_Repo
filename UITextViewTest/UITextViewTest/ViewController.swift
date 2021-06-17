//
//  ViewController.swift
//  UITextViewTest
//
//  Created by 장혜령 on 2021/06/16.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private let restoreFrameValue = 0.0
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let restoreFrameValue = view.frame.origin.y
        let textView = UITextView()
        textView.frame = CGRect(x: 0, y: 44, width: 200, height: 100)
        
        textView.backgroundColor = .gray
        
        view.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.snp.makeConstraints{make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        
        textView.delegate = self
        
        setContentTextViewConstraint()
        
    }
    
    func setContentTextViewConstraint(){
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.snp.makeConstraints{make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        contentTextView.font = UIFont.preferredFont(forTextStyle: .headline)
    
        contentTextView.delegate = self
    }
    
     


}

extension ViewController: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text) //이렇게 보면 한글자씩 이어져찍힌다는 것을 알 수 있음
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.snp.remakeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(estimatedSize)
        }
        
//        if estimatedSize.height > textView.frame.height
//            && estimatedSize.height < 300
//        {
//            textView.snp.remakeConstraints{ make in
//                make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
//                make.height.equalTo(estimatedSize)
//            }
//        }
//

    }
}


// MARK:keyboard
//extension ViewController{
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//
//    }
//
//    @objc func keyboardWillAppear(noti: Notification){
//        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            self.view.frame.origin.y -= keyboardHeight
//        }
//        print("keyboard Will appear Execute")
//    }
//
//
//    @objc func keyboardWillDisappear(noti: NSNotification) {
//        if self.view.frame.origin.y != CGFloat(restoreFrameValue) {
//            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                let keyboardRectangle = keyboardFrame.cgRectValue
//                let keyboardHeight = keyboardRectangle.height
//                self.view.frame.origin.y += keyboardHeight
//            }
//            print("keyboard Will Disappear Execute")
//        }
//    }
//
//}
