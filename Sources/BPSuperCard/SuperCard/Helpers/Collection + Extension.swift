//
//  Collection + Extension.swift
//
//  Created by Савва Шулятьев on 17.01.2023.
//

internal extension Collection where Element: Comparable & SignedNumeric {

  func nearestElement(to value: Element) -> Element? {
    // swiftformat:disable:next redundantSelf
    return self.min(by: { abs($0 - value) < abs($1 - value) })
  }

}
