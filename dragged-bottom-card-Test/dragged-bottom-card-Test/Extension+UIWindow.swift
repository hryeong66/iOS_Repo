//
//  Extension+UIWindow.swift
//  dragged-bottom-card-Test
//
//  Created by 장혜령 on 2021/08/01.
//

import UIKit
extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
