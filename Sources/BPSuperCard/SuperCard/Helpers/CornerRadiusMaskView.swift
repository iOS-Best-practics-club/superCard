//
//  CornerRadiusMaskView.swift
//
//  Created by Савва Шулятьев on 18.01.2023.
//

import UIKit

internal final class CornerRadiusMaskView: UIImageView {

  let radius: CGFloat

  init(radius: CGFloat) {
    self.radius = radius
    super.init(frame: .zero)
    image = UIImage.make(byRoundingCorners: [.topLeft, .topRight], radius: radius)
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
