//
//  CustomJSONDecoder.swift
//  Find Conflicts
//
//  Created by Art Derkint on 6/12/21.
//

import Foundation

final class CustomJSONDecoder: JSONDecoder {
  
  private let customDateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d, yyyy h:mm a"
    formatter.locale = Locale(identifier: "en_US")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
  }()

  override init() {
    super.init()
    /// Assign custom date decoding strategy so that Decodable would be able to parse the date format provided
    dateDecodingStrategy = .formatted(customDateFormat)
  }
}
