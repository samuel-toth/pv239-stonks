//
//  DateExtension.swift
//  Stonks
//
//  Created by Samuel Tóth on 14/04/2023.
//

import Foundation

extension Date {
    func dateToFormattedDatetime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd.MM.YY"
        return dateFormatter.string(from: self)
    }
    
    func dateToFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY"
        return dateFormatter.string(from: self)
    }
}
