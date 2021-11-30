//
//  Date+Extensions.swift
//  Find Conflicts
//
//  Created by Art Derkint on 6/13/21.
//

import Foundation

extension Date {

  /// Returns start of the day date + 1 sec to avoid weird edge cases where it falls back in previous day
  var startOfDay: Date {
    Calendar.current.startOfDay(for: self).addingTimeInterval(1)
  }

  /// Returns formatted date string like `12:00 PM`
  var hoursAndMinutes: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter.string(from: self)
  }

  /// Returns formatted date string like `June 12, 2021`
  var monthDayYear: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d, yyyy"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter.string(from: self)
  }
}
