//
//  UIScrollViewProxy.swift
//
//  Created by Савва Шулятьев on 18.01.2023.
//

import UIKit

final class ScrollViewProxy: NSObject, UIScrollViewDelegate {

  // MARK: - Init

  init(scrollView: UIScrollView?) {
    super.init()

    self.scrollView = scrollView
    self.originalScrollDelegate = scrollView?.delegate
    scrollView?.delegate = self
  }

  deinit {
    self.remove()
  }

  // MARK: - Public methods

  func set(scrollView: UIScrollView) {
    if self.scrollView != nil, self.originalScrollDelegate != nil {
      scrollView.delegate = originalScrollDelegate
    }

    self.scrollView = scrollView
    self.originalScrollDelegate = scrollView.delegate
    scrollView.delegate = self
  }

  /// Removes ourselves as an observer, resetting the scroll view's original delegate
  func remove() {
    self.scrollView?.delegate = self.originalScrollDelegate
  }

  func addListener(_ listener: UIScrollViewDelegate) {
    notifier.subscribe(listener)
  }

  func removeListener(_ listener: UIScrollViewDelegate) {
    notifier.unsubscribe(listener)
  }

  // MARK: - Private Properties

  private let notifier = Notifier<UIScrollViewDelegate>()

  fileprivate weak var scrollView: UIScrollView?
  fileprivate weak var originalScrollDelegate: UIScrollViewDelegate?

  // MARK: - Proxy Delegates

  /// Note: we forward all delegate calls here since Swift does not support forwardInvocation: or NSProxy

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Run any custom logic or send any notifications here
    notifier.forEach { $0.scrollViewDidScroll?(scrollView) }

    // Then, forward the call to the original delegate
    self.originalScrollDelegate?.scrollViewDidScroll?(scrollView)
  }

  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    notifier.forEach { $0.scrollViewDidZoom?(scrollView) }
    self.originalScrollDelegate?.scrollViewDidZoom?(scrollView)
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    notifier.forEach { $0.scrollViewWillBeginDragging?(scrollView) }
    self.originalScrollDelegate?.scrollViewWillBeginDragging?(scrollView)
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    notifier.forEach { $0.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset) }
    self.originalScrollDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    notifier.forEach { $0.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate) }
    self.originalScrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
  }

  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    notifier.forEach { $0.scrollViewWillBeginDecelerating?(scrollView) }
    self.originalScrollDelegate?.scrollViewWillBeginDecelerating?(scrollView)
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    notifier.forEach { $0.scrollViewDidEndDecelerating?(scrollView) }
    self.originalScrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
  }

  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    notifier.forEach { $0.scrollViewDidEndScrollingAnimation?(scrollView) }
    self.originalScrollDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
  }

  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return self.originalScrollDelegate?.viewForZooming?(in: scrollView)
  }

  func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    notifier.forEach { $0.scrollViewWillBeginZooming?(scrollView, with: view) }
    self.originalScrollDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
  }

  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    notifier.forEach { $0.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale) }
    self.originalScrollDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
  }

  func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
    return self.originalScrollDelegate?.scrollViewShouldScrollToTop?(scrollView) == true
  }

  func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    notifier.forEach { $0.scrollViewDidScrollToTop?(scrollView) }
    self.originalScrollDelegate?.scrollViewDidScrollToTop?(scrollView)
  }

}
