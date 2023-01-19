# BPSuperCard

# Overview

This simple and harmonious card supports 5 height states. Swift only

# Usage

```swift
let headerView = HeaderView()
headerView.translatesAutoresizingMaskIntoConstraints = false
headerView.heightAnchor.constraint(equalToConstant: 64).isActive = true

let tableView = UITableView()

let superCardView = SuperCardView(scrollView: tableView, headerView: headerView)
superCardView.availableStates = [.top, .middle, .upperMiddle, .bottom]
superCardView.middlePosition = .fromBottom(256)
superCardView.middlePosition = .fromTop(156)
superCardView.cornerRadius = 16
superCardView.containerView.backgroundColor = .white
superCardView.setState(.middle, animated: false)

// More functions 
superCardView.animationParameters = .spring(mass: 1, stiffness: 200, dampingRatio: 0.5)

// Default UIScrollView like behavior
superCardView.animationParameters = .spring(.default)

```

## Installation

## Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/iOS-Best-practics-club/superCard.git")
]
```

# Requirements

* iOS 11+

## Author

Ilya Lobanov

Complete by Savva Shuliatev

## License

BPSuperCard is available under the MIT license. See the LICENSE file for more info.

