//
//  SuperCardViewController.swift
//
//  Created by Савва Шулятьев on 21.01.2023.
//

import UIKit
/*

 open class SuperCardViewController: UIViewController {

 private var superCardView: SuperCardView!

 // MARK: - Private properties

 private var portraitConstraints: [NSLayoutConstraint] = []
 private var landscapeConstraints: [NSLayoutConstraint] = []
 private var isFirstLayout = true

 // MARK: - Lifecycle

 open override func viewDidLoad() {
 super.viewDidLoad()
 }

 open override func viewDidLayoutSubviews() {
 super.viewDidLayoutSubviews()
 if isFirstLayout {
 isFirstLayout = false
 updateLayoutWithCurrentOrientation()
 superCardView.setState(
 UIDevice.current.orientation.isLandscape ? .top : .middle,
 animated: false
 )
 }
 }

 // MARK: - Override

 open override func viewWillTransition(
 to size: CGSize,
 with coordinator: UIViewControllerTransitionCoordinator
 ) {
 super.viewWillTransition(to: size, with: coordinator)

 let prevState = superCardView.state

 updateLayoutWithCurrentOrientation()

 coordinator.animate(alongsideTransition: { [weak self] context in
 let newState: SuperCardView.State = (prevState == .bottom) ? .bottom : .top
 self?.superCardView.setState(newState, animated: context.isAnimated)
 })

 }

 // MARK: - Private methods

 private func updateLayoutWithCurrentOrientation() {
 let orientation = UIDevice.current.orientation

 if orientation.isLandscape {
 portraitConstraints.forEach { $0.isActive = false }
 landscapeConstraints.forEach { $0.isActive = true }
 superCardView.topPosition = .fromTop(0)
 superCardView.availableStates = [.top, .bottom]
 } else if orientation.isPortrait {
 landscapeConstraints.forEach { $0.isActive = false }
 portraitConstraints.forEach { $0.isActive = true }
 superCardView.topPosition = .fromTop(0)
 superCardView.availableStates = [.top, .upperMiddle, .middle, .lowMiddle, .bottom]
 }
 }

 // MARK: - Layout

 private func layout() {
 superCardView.translatesAutoresizingMaskIntoConstraints = false

 let portraitConstraints = [
 superCardView.topAnchor.constraint(equalTo: view.topAnchor),
 superCardView.leftAnchor.constraint(equalTo: view.leftAnchor),
 superCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
 superCardView.rightAnchor.constraint(equalTo: view.rightAnchor),
 ]

 let landscapeLeftAnchor: NSLayoutXAxisAnchor
 if #available(iOS 11.0, *) {
 landscapeLeftAnchor = view.safeAreaLayoutGuide.leftAnchor
 } else {
 landscapeLeftAnchor = view.leftAnchor
 }

 let landscapeConstraints = [
 superCardView.topAnchor.constraint(equalTo: view.topAnchor),
 superCardView.leftAnchor.constraint(equalTo: landscapeLeftAnchor, constant: 16),
 superCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
 superCardView.widthAnchor.constraint(equalToConstant: 320),
 ]

 self.portraitConstraints = portraitConstraints
 self.landscapeConstraints = landscapeConstraints
 }

 }
 */
