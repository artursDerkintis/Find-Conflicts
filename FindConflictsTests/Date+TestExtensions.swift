//
//  Date+TestExtensions.swift
//  FindConflictsTests
//
//  Created by Art Derkint on 6/13/21.
//

import Foundation

extension Date {
  static func date(_ hmm: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    let comp = Calendar(identifier: .gregorian).dateComponents([.hour, .minute], from: formatter.date(from: hmm)!)
    return date(year: 2018, month: 1, day: 1, hour: comp.hour!, minute: comp.minute!)
  }

  static func date(year: Int,
                   month: Int,
                   day: Int,
                   hour: Int,
                   minute: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    components.timeZone = TimeZone(secondsFromGMT: 0)
    return Calendar(identifier: .gregorian).date(from: components)!
  }

}
