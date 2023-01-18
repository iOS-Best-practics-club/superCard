//
//  SuperCardView.swift
//
//  Created by Савва Шулятьев on 15.01.2023.
//

import UIKit

public protocol SuperCardViewDelegate: AnyObject {
  func superCardView(
    _ superCardView: SuperCardView,
    willBeginUpdatingOrigin origin: CGFloat,
    source: SuperCardViewOriginChangeSource
  )

  func superCardView(
    _ superCardView: SuperCardView,
    didUpdateOrigin origin: CGFloat,
    source: SuperCardViewOriginChangeSource
  )

  func superCardView(
    _ superCardView: SuperCardView,
    didEndUpdatingOrigin origin: CGFloat,
    source: SuperCardViewOriginChangeSource
  )

  func superCardView(
    _ superCardView: SuperCardView,
    didChangeState state: SuperCardView.State?
  )

  func superCardView(
    _ superCardView: SuperCardView,
    willBeginAnimationToState state: SuperCardView.State?,
    source: SuperCardViewOriginChangeSource
  )
}

open class SuperCardView: UIView {

  public typealias Content = SuperCardViewContent

  // MARK: - Public enums

  public enum State {
    case top
    case upperMiddle
    case middle
    case lowMiddle
    case bottom
    case dismissed
  }

  public struct RelativePosition {
    public enum Edge {
      case top
      case bottom
    }

    public enum Point {
      case drawerOrigin
      case contentOrigin
    }

    public var offset: CGFloat

    public var edge: Edge

    public var point: Point

    /// Safe area is equal to .safeAreaInsets for iOS 11+.
    /// For iOS 10 it contains only status bar.
    public var ignoresSafeArea: Bool

    /// Indicates whether or not the drawer positions should be constrained by the content size.
    public var ignoresContentSize: Bool

    public init(
      offset: CGFloat,
      edge: Edge,
      point: Point = .drawerOrigin,
      ignoresSafeArea: Bool = false,
      ignoresContentSize: Bool = true
    ) {//
      self.offset = offset
      self.edge = edge
      self.point = point
      self.ignoresSafeArea = ignoresSafeArea
      self.ignoresContentSize = ignoresContentSize
    }

    public static func fromTop(
      _ offset: CGFloat,
      relativeTo point: Point = .drawerOrigin,
      ignoresSafeArea: Bool = false,
      ignoresContentSize: Bool = true
    ) -> RelativePosition {
      return RelativePosition(
        offset: offset,
        edge: .top,
        point: point,
        ignoresSafeArea: ignoresSafeArea,
        ignoresContentSize: ignoresContentSize
      )
    }

    public static func fromBottom(
      _ offset: CGFloat,
      relativeTo point: Point = .drawerOrigin,
      ignoresSafeArea: Bool = false,
      ignoresContentSize: Bool = true
    ) -> RelativePosition {
      return RelativePosition(
        offset: offset,
        edge: .bottom,
        point: point,
        ignoresSafeArea: ignoresSafeArea,
        ignoresContentSize: ignoresContentSize
      )
    }
  }

  public struct PositionDependencies {
    public var boundsHeight: CGFloat
    public var headerHeight: CGFloat
    public var safeAreaInsets: UIEdgeInsets

    public init(boundsHeight: CGFloat, headerHeight: CGFloat, safeAreaInsets: UIEdgeInsets) {
      self.boundsHeight = boundsHeight
      self.headerHeight = headerHeight
      self.safeAreaInsets = safeAreaInsets
    }
  }

  // MARK: - Public properties

  open var content: Content {
    return snappingView.content
  }

  open var containerView: UIView {
    return snappingView.containerView
  }

  open var headerView: UIView {
      return snappingView.headerView
  }

  open var origin: CGFloat {
    return snappingView.origin
  }

  open var topPosition: RelativePosition = .fromTop(0) {
    didSet {
      updateAnchors()
    }
  }

  open var upperMiddlePosition: RelativePosition = .fromBottom(0, relativeTo: .contentOrigin) {
    didSet {
      updateAnchors()
    }
  }

  open var middlePosition: RelativePosition = .fromBottom(0, relativeTo: .contentOrigin) {
    didSet {
      updateAnchors()
    }
  }

  open var lowMiddlePosition: RelativePosition = .fromBottom(0, relativeTo: .contentOrigin) {
    didSet {
      updateAnchors()
    }
  }

  open var bottomPosition: RelativePosition = .fromBottom(0, relativeTo: .contentOrigin) {
    didSet {
      updateAnchors()
    }
  }

  /// Indicates whether or not the drawer fades its content in bottom state
  open var shouldFadeInBottomState: Bool = true

  /// Animation parameters for the transitions between anchors
  open var animationParameters: AnimationParameters {
    get {
      return snappingView.animationParameters
    }
    set {
      snappingView.animationParameters = newValue
    }
  }

  open var cornerRadius: CGFloat {
    set {
      if newValue > 0 {
        containerView.mask = CornerRadiusMaskView(radius: newValue)
        containerView.mask?.frame = bounds
      } else {
        containerView.mask = nil
      }
    }
    get {
      return (containerView.mask as? CornerRadiusMaskView)?.radius ?? 0
    }
  }

  open var bounces: Bool {
    get {
      return snappingView.bounces
    }
    set {
      snappingView.bounces = newValue
    }
  }

  open var state: State? {
    return state_
  }

  open var availableStates: Set<State> = [.top, .bottom, .middle] {
    didSet {
      if let s = state_, !availableStates.contains(s) {
        state_ = nil
      }
      updateAnchors()
    }
  }

  // MARK: - Public methods

  open func setState(_ state: State, animated: Bool, completion: ((Bool) -> Void)? = nil) {
    guard availableStates.contains(state) else { return }

    state_ = state

    snappingView.scroll(toOrigin: anchor(for: state), animated: animated, completion: completion)
  }

  /// Origins are layout dependent. All dependencies are declared in PositionDependencies.
  /// Use 'targetOrigin:for:positionDependencies' method if the view is not layouted.
  open func origin(for state: State) -> CGFloat {
    return anchor(for: state)
  }


  open func targetOrigin(for state: State, positionDependencies: PositionDependencies) -> CGFloat {
    return targetAnchor(for: state, positionDependencies: positionDependencies)
  }

  open func addListener(_ listener: SuperCardViewDelegate) {
    notifier.subscribe(listener)
  }

  open func removeListener(_ listener: SuperCardViewDelegate) {
    notifier.unsubscribe(listener)
  }

  // MARK: - Init

  public init(content: Content, headerView: UIView) {
    self.snappingView = SuperSnappingView(content: content, headerView: headerView)

    super.init(frame: .zero)

    setupViews()
    content.addListener(self)
    snappingView.addListener(self)
  }

  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    // https://bugs.swift.org/browse/SR-5816
    headerObservation = nil
  }

  // MARK: - UIView

  override open func layoutSubviews() {
    super.layoutSubviews()

    containerView.mask?.frame = bounds

    updateAnchors()

    if let animationSession = animationSession_, let state = animationSession.targetState {
      animationSession.animation.targetOrigin = origin(for: state)
    } else if let state = state, !snappingView.isDragging {
      setState(state, animated: false)
    }
  }

  @available(iOS 11.0, *)
  override open func safeAreaInsetsDidChange() {
    super.safeAreaInsetsDidChange()
    updateAnchors()
    if state == .bottom {
      setState(.bottom, animated: false)
    }
  }

  override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return snappingView.point(inside: point, with: event)
  }

  // MARK: - Private properties

  private let snappingView: SuperSnappingView

  private var headerObservation: NSKeyValueObservation?

  private let notifier = Notifier<SuperCardViewDelegate>()

  // MARK: - SetupViews

  private func setupViews() {
    addSubview(snappingView)
    snappingView.frame = bounds
    snappingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    headerObservation = headerView.observe(\.bounds, options: .new) { [weak self] _, _ in
      self?.updateAnchors()
    }
  }

  // MARK: - Private methods

  private var currentPositionDependencies: PositionDependencies {
    return PositionDependencies(
      boundsHeight: bounds.height,
      headerHeight: headerView.frame.height,
      safeAreaInsets: getSafeAreaInsets()
    )
  }

  private func getSafeAreaInsets() -> UIEdgeInsets {
    if #available(iOS 11.0, *) {
      return safeAreaInsets
    } else {
      var result: UIEdgeInsets = .zero

      let statusBarFrame = UIApplication.shared.statusBarFrame
      if statusBarFrame != .zero { // if status bar in not hidden
        if let maxY = UIApplication.shared.keyWindow?.convert(statusBarFrame, to: self).maxY, maxY > 0 {
          result.top = maxY
        }
      }

      return result
    }
  }

  private func updateContentVisibility() {
    guard #available(iOS 11.0, *), shouldFadeInBottomState, safeAreaInsets.bottom > 0 else {
      content.view.alpha = 1
      return
    }

    let fadingDistance: CGFloat = 40

    let diff = anchor(for: .bottom) - origin
    content.view.alpha = (diff / fadingDistance).clamped(to: 0 ... 1)
  }

  // MARK: - Work with Anchors

  private struct AssociatedAnchor {
    var state: State
    var anchor: CGFloat
  }

  private var state_: State? {
    didSet {
      if state_ != oldValue {
        notifier.forEach { $0.superCardView(self, didChangeState: state_) }
      }
    }
  }

  private var availableAnchors: [AssociatedAnchor] {
      return availableStates.map { AssociatedAnchor(state: $0, anchor: anchor(for: $0)) }
  }

  private func updateAnchors() {
      snappingView.anchors = availableAnchors.map(\.anchor)
  }

  private func anchor(for state: State) -> CGFloat {
    return targetAnchor(for: state, positionDependencies: currentPositionDependencies)
  }

  private func targetAnchor(for state: State, positionDependencies: PositionDependencies) -> CGFloat {
    switch state {
    case .top:
      return targetAnchorForTop(with: positionDependencies)
    case .upperMiddle:
      return targetAnchorForUpperMiddle(with: positionDependencies)
    case .middle:
      return targetAnchorForMiddle(with: positionDependencies)
    case .lowMiddle:
      return targetAnchorForLowMiddle(with: positionDependencies)
    case .bottom:
      return targetAnchorForBottom(with: positionDependencies)
    case .dismissed:
      return targetAnchorForDismissed(with: positionDependencies)
    }
  }

  private func targetAnchorForTop(with positionDependencies: PositionDependencies) -> CGFloat {
    return targetOrigin(for: topPosition, positionDependencies: positionDependencies)
  }

  private func targetAnchorForUpperMiddle(with positionDependencies: PositionDependencies) -> CGFloat {
    return targetOrigin(for: upperMiddlePosition, positionDependencies: positionDependencies)
  }

  private func targetAnchorForMiddle(with positionDependencies: PositionDependencies) -> CGFloat {
    return targetOrigin(for: middlePosition, positionDependencies: positionDependencies)
  }

  private func targetAnchorForLowMiddle(with positionDependencies: PositionDependencies) -> CGFloat {
    return targetOrigin(for: lowMiddlePosition, positionDependencies: positionDependencies)
  }

  private func targetAnchorForBottom(with positionDependencies: PositionDependencies) -> CGFloat {
    return targetOrigin(for: bottomPosition, positionDependencies: positionDependencies)
  }

  private func targetAnchorForDismissed(with positionDependencies: PositionDependencies) -> CGFloat {
    return positionDependencies.boundsHeight
  }

  private func targetOrigin(for position: RelativePosition, positionDependencies: PositionDependencies) -> CGFloat {
    let candidate = SuperCardView.targetOriginIgnoringContentSize(for: position, positionDependencies: positionDependencies)

    if position.ignoresContentSize {
      return candidate
    } else {
      let totalHeight = content.contentSize.height + content.contentInset.top + content.contentInset.bottom
      let contentOriginPosition: RelativePosition = .fromBottom(totalHeight, relativeTo: .contentOrigin)

      let contentOrigin = SuperCardView.targetOriginIgnoringContentSize(
        for: contentOriginPosition,
        positionDependencies: positionDependencies
      )

      return max(candidate, contentOrigin)
    }
  }

  private static func targetOriginIgnoringContentSize(
    for position: RelativePosition,
    positionDependencies: PositionDependencies
  ) -> CGFloat {
    var result: CGFloat = position.offset

    switch position.edge {
    case .top:
      if !position.ignoresSafeArea {
        result += positionDependencies.safeAreaInsets.top
      }
    case .bottom:
      result = positionDependencies.boundsHeight - result

      if !position.ignoresSafeArea {
        result -= positionDependencies.safeAreaInsets.bottom
      }
    }

    if position.point == .contentOrigin {
      result -= positionDependencies.headerHeight
    }

    return result
  }

  private func state(forOrigin origin: CGFloat) -> State? {
    let eps: CGFloat = 1 / UIScreen.main.scale
    let anchors = availableAnchors.sorted { $0.anchor < $1.anchor }
    return anchors.first(where: { $0.anchor.distance(to: origin) < eps })?.state
  }

  // MARK: - Private: Animation

  class AnimationSession {
    let animation: SnappingViewAnimation
    var targetState: State?

    init(animation: SnappingViewAnimation, targetState: State?) {
      self.animation = animation
      self.targetState = targetState
    }
  }

  var animationSession_: AnimationSession?

}

// MARK: - SuperCardViewContentDelegate

extension SuperCardView: SuperCardViewContentDelegate {
  public func superCardViewContent(
    _ superCardViewContent: SuperCardViewContent,
    didChangeContentSize contentSize: CGSize
  ) {
    setNeedsLayout()
  }

  public func superCardViewContent(
    _ superCardViewContent: SuperCardViewContent,
    didChangeContentInset contentInset: UIEdgeInsets
  ) {
    setNeedsLayout()
  }

  public func superCardViewContentDidScroll(_ superCardViewContent: SuperCardViewContent) {}

  public func superCardViewContentWillBeginDragging(_ superCardViewContent: SuperCardViewContent) {}

  public func superCardViewContentWillEndDragging(
    _ superCardViewContent: SuperCardViewContent,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {}

}

// MARK: - SnappingViewListener

extension SuperCardView: SnappingViewListener {
  public func snappingView(
    _ snappingView: SuperSnappingView,
    willBeginUpdatingOrigin origin: CGFloat,
    source: SuperCardViewOriginChangeSource
  ) {
    notifier.forEach { $0.superCardView(self, willBeginUpdatingOrigin: origin, source: source) }
  }

  public func snappingView(
    _ snappingView: SuperSnappingView,
    didUpdateOrigin origin: CGFloat,
    source: SuperCardViewOriginChangeSource
  ) {
    updateContentVisibility()
    notifier.forEach { $0.superCardView(self, didUpdateOrigin: origin, source: source) }
  }

  public func snappingView(
    _ snappingView: SuperSnappingView,
    didEndUpdatingOrigin origin: CGFloat,
    source: SuperCardViewOriginChangeSource
  ) {
    if let newState = state(forOrigin: origin), source == .contentInteraction || source == .headerInteraction {
      state_ = newState
    }

    animationSession_ = nil

    notifier.forEach { $0.superCardView(self, didEndUpdatingOrigin: origin, source: source) }
  }

  public func snappingView(
    _ snappingView: SuperSnappingView,
    willBeginAnimation animation: SnappingViewAnimation,
    source: SuperCardViewOriginChangeSource
  ) {
    let targetState = state(forOrigin: animation.targetOrigin)
    animationSession_ = AnimationSession(animation: animation, targetState: targetState)

    notifier.forEach { $0.superCardView(self, willBeginAnimationToState: targetState, source: source) }
  }
}
