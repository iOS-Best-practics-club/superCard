# BPSuperCard

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

// More fluctuations 
superCardView.animationParameters = .spring(mass: 1, stiffness: 200, dampingRatio: 0.5)

// Default UIScrollView like behavior
superCardView.animationParameters = .spring(.default)

```

## Installation

UltraDrawerView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```swift

```

## Author

Ilya Lobanov

Complete by Savva Shuliatev

## License

SuperCard is available under the MIT license. See the LICENSE file for more info.

