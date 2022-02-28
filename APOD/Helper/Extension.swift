//
//  Extension.swift
//  APOD
//
//  Created by Vahida on 28/02/22.
//

import Foundation
import UIKit

extension Date {
    func Tostring(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = Date.init()
        return formatter.string(from: date)
    }
}

extension UIViewController
{
    func SetDarKMode()
    {
        self.view.overrideUserInterfaceStyle = .dark
    }
}
