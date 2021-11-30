//
//  FindConflictsApp.swift
//  Find Conflicts
//
//  Created by Art Derkint on 6/12/21.
//

import SwiftUI

@main
struct FindConflictsApp: App {
  var body: some Scene {
    WindowGroup {
      EventTable(source: EventSource())
    }
  }
}
