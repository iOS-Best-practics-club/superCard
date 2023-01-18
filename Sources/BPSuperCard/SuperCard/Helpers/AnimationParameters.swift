//
//  AnimationParameters.swift
//
//  Created by Савва Шулятьев on 17.01.2023.
//

import Foundation
import CoreGraphics

public enum AnimationParameters {
  case spring(Spring)
}


public extension AnimationParameters {

  static func spring(mass: CGFloat, stiffness: CGFloat, dampingRatio: CGFloat) -> AnimationParameters {
    return .spring(Spring(mass: mass, stiffness: stiffness, dampingRatio: dampingRatio))
  }

}
