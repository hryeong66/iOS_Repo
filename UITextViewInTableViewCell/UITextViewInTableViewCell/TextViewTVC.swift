//
//  TextViewTVC.swift
//  UITextViewInTableViewCell
//
//  Created by 장혜령 on 2021/06/17.
//

import UIKit
import SnapKit

protocol TableViewCellDelegate {
    func updateTextViewHeight(_ cell:UITableViewCell,_ textView:UITextView)
}


class TextViewTVC: UITableViewCell {

    static let identifier = "TextViewTVC"
    public var delegate: TableViewCellDelegate?
    private var contentTextView = UITextView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLayout()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpLayout(){
        super.layoutSubviews()
        addSubview(contentView)
        contentTextView.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
            make.trailing.equalTo(self.snp.trailing)
            
        }
    }
    
    private func setTextViewStyle(){
        contentTextView.adjustsFontForContentSizeCategory = false
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.blue.cgColor
        contentTextView.layer.cornerRadius = 10
        contentTextView.textColor = .black
    }
    
    
}

//MARK: TextViewDelegate
extension TextViewTVC:UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if let delegate = delegate {
            delegate.updateTextViewHeight(self, textView)
        }
    }
}
