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

class ReactionButtonTests: XCTestCase {
  func testReactionButton() {
    let button = ReactionButton()

    XCTAssertNotNil(button)
    XCTAssertFalse(button.isSelected)
    XCTAssertEqual(button.reaction, Reaction.facebook.like)
    XCTAssertNotNil(button.config)
    XCTAssertNil(button.reactionSelector)
  }

  func testSetSelected() {
    let button = ReactionButton()

    XCTAssertFalse(button.isSelected)

    button.isSelected = true

    XCTAssertTrue(button.isSelected)
  }

  func testSetReaction() {
    let button = ReactionButton()

    XCTAssertEqual(button.reaction, Reaction.facebook.like)

    button.reaction = Reaction.facebook.love

    XCTAssertEqual(button.reaction, Reaction.facebook.love)
  }

  func testSetReactionSelect() {
    let button = ReactionButton()

    XCTAssertNil(button.reactionSelector)

    let select              = ReactionSelector()
    button.reactionSelector = select

    XCTAssertEqual(button.reactionSelector, select)
    XCTAssertNotNil(select.superview)

    button.reactionSelector = nil

    XCTAssertNil(button.reactionSelector)
    XCTAssertNil(select.superview)
  }

  func testSetConfig() {
    let button = ReactionButton()

    button.config = ReactionButtonConfig {
      $0.neutralTintColor = .red
      $0.alignment        = .right
    }

    XCTAssertEqual(button.config.alignment, .right)
    XCTAssertEqual(button.config.neutralTintColor, .red)

    button.config = ReactionButtonConfig {
      $0.alignment = .centerLeft
    }

    XCTAssertEqual(button.config.alignment, .centerLeft)

    button.config = ReactionButtonConfig {
      $0.alignment = .centerRight
    }

    XCTAssertEqual(button.config.alignment, .centerRight)
  }

  func testPresentReactionSelector() {
    let button              = ReactionButton()
    button.reactionSelector = ReactionSelector()

    button.presentReactionSelector()

    button.config = ReactionButtonConfig {
      $0.alignment = .right
    }

    button.presentReactionSelector()

    button.config = ReactionButtonConfig {
      $0.alignment = .centerLeft
    }

    button.presentReactionSelector()
  }

  func testDismissReactionSelector() {
    let button              = ReactionButton()
    button.reactionSelector = ReactionSelector()

    button.dismissReactionSelector()
  }

  func testTapButton() {
    let tap = UITapGestureRecognizer()

    let control              = ReactionButton()
    control.reactionSelector = ReactionSelector()

    control.tapAction(tap)
  }

  func testLongPressButtonWithNoSelector() {
    let control = ReactionButton()

    control.longPressAction(UILongPressGestureRecognizer())
  }

  func testLongPressButtonWithSelector() {
    class PressBeganGesture: UILongPressGestureRecognizer {
      var currentState: UIGestureRecognizer.State = .began

      override var state: UIGestureRecognizer.State {
        get {
          return currentState
        }
        set {}
      }
    }

    let press = PressBeganGesture()

    let control              = ReactionButton()
    control.reactionSelector = ReactionSelector()

    // Long Press with move

    control.longPressAction(press)

    press.currentState = .changed

    control.longPressAction(press)

    press.currentState = .ended

    control.longPressAction(press)

    // Long Press without move

    press.currentState = .began

    control.longPressAction(press)

    press.currentState = .ended

    control.longPressAction(press)
  }

  func testLongPressReactionSelector() {
    class PressBeganGesture: UILongPressGestureRecognizer {
      var currentState: UIGestureRecognizer.State = .began

      override var state: UIGestureRecognizer.State {
        get {
          return currentState
        }
        set {}
      }

      override func location(in view: UIView?) -> CGPoint {
        return CGPoint(x: 10, y: 10)
      }
    }

    let press = PressBeganGesture()

    let control                     = ReactionButton()
    control.reactionSelector        = ReactionSelector()
    control.reactionSelector?.frame = control.reactionSelector?.boundsToFit() ?? .zero

    control.reactionSelector?.longPressAction(press)

    press.currentState = .changed

    control.reactionSelector?.longPressAction(press)
    
    press.currentState = .ended
    
    control.reactionSelector?.longPressAction(press)

    control.reactionSelector?.reactions = [Reaction.facebook.like]

    control.reactionSelector?.longPressAction(press)

    control.presentReactionSelector()
  }
}
