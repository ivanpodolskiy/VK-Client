//
//  AsyncOperation.swift
//  LessonOne
//
//  Created by user on 14.12.2021.
//

import Foundation

class AsyncOperation: Operation {

  enum State: String {
    case ready, executing, finished

    fileprivate var keyPath: String {
      return "is" + self.rawValue.capitalized
    }
  }

  var state: State = State.ready {
    willSet {
      self.willChangeValue(forKey: self.state.keyPath)
      self.willChangeValue(forKey: newValue.keyPath)
    }

    didSet {
      self.didChangeValue(forKey: self.state.keyPath)
      self.didChangeValue(forKey: oldValue.keyPath)
    }
  }



  override var isAsynchronous: Bool {
    return true
  }

  override var isReady: Bool {
    return super.isReady && self.state == .ready
  }

  override var isExecuting: Bool {
    return self.state == .executing
  }

  override var isFinished: Bool {
    return self.state == .finished
  }

  override func start() {
    if self.isCancelled {
      self.state = .finished
    } else {
      self.main()
      self.state = .executing
    }
  }

  override func cancel() {
    super.cancel()
    self.state = .finished
  }

  func finished() {
    self.state = .finished
  }
}
