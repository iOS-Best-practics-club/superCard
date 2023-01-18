//
//  Notifier.swift
//
//  Created by Савва Шулятьев on 17.01.2023.
//

import Foundation

internal final class Notifier<Listener> {

  init() {
    self.listeners = WeakCollection<Listener>()
  }

  func subscribe(_ listener: Listener) {
    listeners.insert(listener)
  }

  func unsubscribe(_ listener: Listener) {
    listeners.remove(listener)
  }

  func forEach(_ block: (Listener) -> Void) {
    listeners.forEach(block)
  }

  var hasNoListeners: Bool {
    return listeners.isEmpty()
  }

  // MARK: - Private

  private var listeners: WeakCollection<Listener>

}
