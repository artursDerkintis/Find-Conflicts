//
//  EventSource.swift
//  Find Conflicts
//
//  Created by Art Derkint on 6/12/21.
//

import Foundation

/// Events source interface
protocol EventsSourceProtocol {
  var events: [Event] { get }
}

/// Events source implementation
final class EventSource: EventsSourceProtocol {
  var events: [Event] {
    guard let path = Bundle.main.path(forResource: "mock", ofType: "json") else {
      assertionFailure("No mock file found in project")
      return []
    }
    guard let data = try? String(contentsOfFile: path).data(using: .utf8) else {
      assertionFailure("Failed to convert the file into data")
      return []
    }
    do {
      let events = try CustomJSONDecoder().decode([Event].self, from: data)
      return events
    } catch {
      assertionFailure("Decoding error \(error)")
      return []
    }
  }
}
