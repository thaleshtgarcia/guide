//
//  DateKit.swift
//  GuideClient
//
//  Created by thales.garcia on 19/11/17.
//  Copyright © 2017 thales.garcia. All rights reserved.
//

import Foundation

extension String {
    public func toDate(withFormat format: String? = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}

extension Date {
    public func toString(withFormat format: String? = "yyyy-MM-dd'T'HH:mm:ssZ") -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
