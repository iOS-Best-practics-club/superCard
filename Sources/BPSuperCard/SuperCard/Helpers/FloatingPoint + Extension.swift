//
//  FloatingPoint + Extension.swift
//
//  Created by Савва Шулятьев on 17.01.2023.
//

import Foundation

internal extension FloatingPoint {

  func isLess(than other: Self, eps: Self) -> Bool {
    return self < other - eps
  }

  func isGreater(than other: Self, eps: Self) -> Bool {
    return self > other + eps
  }

  func isEqual(to other: Self, eps: Self) -> Bool {
    return abs(self - other) < eps
  }

}
