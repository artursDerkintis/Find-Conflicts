//
//  EventTableCell.swift
//  Find Conflicts
//
//  Created by Art Derkint on 6/12/21.
//

import SwiftUI

/// Event cell to display data about the event
struct EventTableCell: View {
  let event: Event
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(event.title)
      Text(event.readableRange)
      if event.hasConflict {
        Text("Conflicting event")
          .foregroundColor(.red)
      }
    }
  }
}

struct EventTableCell_Previews: PreviewProvider {
  static var previews: some View {
    var event = Event(title: "Event 1", start: Date(), end: Date())
    event.hasConflict = true
    return EventTableCell(event: event)
  }
}
