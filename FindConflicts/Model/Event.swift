//
//  Event.swift
//  Find Conflicts
//
//  Created by Art Derkint on 6/12/21.
//

import Foundation

struct Event: Decodable {

  /// Event id - since we don't receive this in response we need some unique Id for SwiftUI list view to work properly
  let id = UUID()

  /// Event title
  let title: String

  /// Event start date
  let start: Date

  /// Event end date
  let end: Date

  /// If Event has a conflicting event(s)
  var hasConflict = false

  /// Decodable support
  private enum CodingKeys: String, CodingKey {
    case title
    case start
    case end
  }

  /// Returns formatted date from start to end
  /// E.G. `12:00 PM - 1:00 PM`
  var readableRange: String {
    "\(start.hoursAndMinutes) - \(end.hoursAndMinutes)"
  }

}
