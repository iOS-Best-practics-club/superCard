//
//  Clamp.swift
//
//  Created by Савва Шулятьев on 17.01.2023.
//

import Foundation

internal extension Comparable {

  func clamped(to limits: ClosedRange<Self>) -> Self {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }

}
