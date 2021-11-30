//
//  EventTable.swift
//  Find Conflicts
//
//  Created by Art Derkint on 6/12/21.
//

import SwiftUI

/// Event table to display events 
struct EventTable: View {

  @ObservedObject private var viewModel: EventsViewModel

  /// Event table constructor
  /// - Parameter source: Events source
  init(source: EventsSourceProtocol) {
    self.viewModel = EventsViewModel(source: source)
  }

  var body: some View {
    List {
      ForEach(viewModel.sectionedEvents, id: \.headerTitle) { section in
        Section(header: EventTableHeader(title: section.headerTitle)) {
          ForEach(section.items, id: \.id) { event in
            EventTableCell(event: event)
          }
        }
      }
    }.listStyle(GroupedListStyle())
  }
}

struct EventTable_Previews: PreviewProvider {
  static var previews: some View {
    EventTable(source: MockEventsSource(events: [Event(title: "Event 1", start: Date(), end: Date())]))
  }

  final class MockEventsSource: EventsSourceProtocol {
    let events: [Event]
    init(events: [Event]) {
      self.events = events
    }
  }
}
