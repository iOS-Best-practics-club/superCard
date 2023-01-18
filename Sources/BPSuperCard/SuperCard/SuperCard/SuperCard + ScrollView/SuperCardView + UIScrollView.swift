//
//  SuperCardView + UIScrollView.swift
//
//  Created by Савва Шулятьев on 18.01.2023.
//

import UIKit

public extension SuperCardView {

  /// It is compatible with any type of `UIScrollView`.
  /// `scrollView.delegate` will be used by `ScrollDrawerViewContent`.
  convenience init(scrollView: UIScrollView, headerView: UIView) {
    self.init(content: ScrollDrawerViewContent(scrollView: scrollView), headerView: headerView)
  }

}

public extension SuperSnappingView {

  /// It is compatible with any type of `UIScrollView`.
  /// `scrollView.delegate` will be used by `ScrollDrawerViewContent`.
  convenience init(scrollView: UIScrollView, headerView: UIView) {
    self.init(content: ScrollDrawerViewContent(scrollView: scrollView), headerView: headerView)
  }

}
