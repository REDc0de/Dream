//
//  Date+Difference.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 05.03.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import Foundation

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: self, to: date).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: self, to: date).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: self, to: date).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: date).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: self, to: date).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: self, to: date).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: self, to: date).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(to date: Date) -> String {
        if years(from: date)   > 0 { return String.localizedStringWithFormat(NSLocalizedString("numberOfYears",   comment: ""), years(from: date))   }
        if months(from: date)  > 0 { return String.localizedStringWithFormat(NSLocalizedString("numberOfMonths",  comment: ""), months(from: date))  }
        if weeks(from: date)   > 0 { return String.localizedStringWithFormat(NSLocalizedString("numberOfWeeks",   comment: ""), weeks(from: date))   }
        if days(from: date)    > 0 { return String.localizedStringWithFormat(NSLocalizedString("numberOfDays",    comment: ""), days(from: date))    }
        if hours(from: date)   > 0 { return String.localizedStringWithFormat(NSLocalizedString("numberOfHours",   comment: ""), hours(from: date))   }
        if minutes(from: date) > 0 { return String.localizedStringWithFormat(NSLocalizedString("numberOfMinutes", comment: ""), minutes(from: date)) }
        if seconds(from: date) > 0 { return String.localizedStringWithFormat(NSLocalizedString("numberOfSeconds", comment: ""), seconds(from: date)) }
        return "0s"
    }
}
