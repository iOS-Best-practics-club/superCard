//
//  SuperCardView + UIView + UIScrollView.swift
//
//  Created by Савва Шулятьев on 20.01.2023.
//

import UIKit

public extension SuperCardView {

  /// It is compatible with any type of `UIScrollView`.
  /// `scrollView.delegate` will be used by `ScrollDrawerViewContent`.
  convenience init(
    contentView: UIView,
    scrollView: UIScrollView? = nil,
    headerView: UIView
  ) {
    self.init(
      content: ViewWithScrollViewCardViewContent(
        contentView: contentView,
        scrollView: scrollView
      ),
      headerView: headerView
    )
  }

}

public extension SuperSnappingView {

  /// It is compatible with any type of `UIScrollView`.
  /// `scrollView.delegate` will be used by `ScrollDrawerViewContent`.
  convenience init(
    contentView: UIView,
    scrollView: UIScrollView? = nil,
    headerView: UIView
  ) {
    self.init(
      content: ViewWithScrollViewCardViewContent(
        contentView: contentView,
        scrollView: scrollView
      ),
      headerView: headerView
    )
  }

}

