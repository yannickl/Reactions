/*
 * Reactions
 *
 * Copyright 2016-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import XCTest
@testable import Reactions

class ReactionSummaryTests: XCTestCase {
  func testInit() {
    let summary = ReactionSummary()

    XCTAssertNil(summary.text)
    XCTAssertNotNil(summary.config)
    XCTAssertEqual(summary.reactions.count, 0)
  }

  func testSetReactions() {
    let summary    = ReactionSummary()
    summary.reactions = Reaction.facebook.all

    XCTAssertEqual(summary.reactions.count, 6)

    summary.reactions = [Reaction.facebook.like]

    XCTAssertEqual(summary.reactions.count, 1)
  }

  func testSetConfig() {
    let summary       = ReactionSummary()
    summary.reactions = Reaction.facebook.all
    summary.config    = ReactionSummaryConfig {
      $0.alignment = .right
    }

    XCTAssertEqual(summary.config.alignment, .right)

    summary.config = ReactionSummaryConfig {
      $0.alignment = .centerLeft
    }

    XCTAssertEqual(summary.config.alignment, .centerLeft)

    summary.config = ReactionSummaryConfig {
      $0.alignment = .centerRight
    }

    XCTAssertEqual(summary.config.alignment, .centerRight)
  }

  func testTapGesture() {
    class Target {
      var count = 0

      @objc func incCountAction(_ sender: AnyObject) {
        count += 1
      }
    }

    let testTarget = Target()

    let summary = ReactionSummary()
    summary.addTarget(testTarget, action: #selector(Target.incCountAction), for: .touchUpInside)

    summary.tapAction(UITapGestureRecognizer())

    XCTAssertEqual(testTarget.count, 1)
  }
}
