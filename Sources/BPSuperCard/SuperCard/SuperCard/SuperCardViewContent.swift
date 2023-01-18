//
//  SuperCardViewContent.swift
//
//  Created by Савва Шулятьев on 15.01.2023.
//

import UIKit

public protocol SuperCardViewContent: AnyObject {
  /// View should be immutable
  var view: UIView { get }
  var contentOffset: CGPoint { get set }
  var contentSize: CGSize { get }
  var contentInset: UIEdgeInsets { get }
  func addListener(_ listener: SuperCardViewContentDelegate)
  func removeListener(_ listener: SuperCardViewContentDelegate)
}

public protocol SuperCardViewContentDelegate: AnyObject {
  func superCardViewContent(
    _ superCardViewContent: SuperCardViewContent,
    didChangeContentSize contentSize: CGSize
  )

  func superCardViewContent(
    _ superCardViewContent: SuperCardViewContent,
    didChangeContentInset contentInset: UIEdgeInsets
  )

  func superCardViewContentDidScroll(_ superCardViewContent: SuperCardViewContent)

  func superCardViewContentWillBeginDragging(_ superCardViewContent: SuperCardViewContent)

  func superCardViewContentWillEndDragging(
    _ superCardViewContent: SuperCardViewContent,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  )
}
