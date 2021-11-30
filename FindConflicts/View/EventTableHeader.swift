//
//  EventTableHeader.swift
//  Find Conflicts
//
//  Created by Art Derkint on 6/12/21.
//

import SwiftUI

/// Header view to display day title for each group of events
struct EventTableHeader: View {
  let title: String
  
  var body: some View {
    Text(title)
      .font(.body)
      .foregroundColor(.accentColor)
  }
}

struct EventTableHeader_Previews: PreviewProvider {
  static var previews: some View {
    EventTableHeader(title: "September 12, 2020")
  }
}
