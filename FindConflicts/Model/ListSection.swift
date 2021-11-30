//
//  ListSection.swift
//  Find Conflicts
//
//  Created by Art Derkint on 6/13/21.
//

import Foundation

/// Helper to make sectioned List easier to assemble
/// `E` is type of array item to use as List cell source
struct ListSection<E> {

  /// Header title for section header in List
  let headerTitle: String

  /// Array of items for List cells
  let items: [E]
}
