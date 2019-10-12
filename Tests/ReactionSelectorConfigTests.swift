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

class ReactionSelectorConfigTests: XCTestCase {
  func testComputedIconSize() {
    let config = ReactionSelectorConfig()

    XCTAssertNil(config.iconSize)
    XCTAssertEqual(config.computedIconSize(highlighted: false), config.defaultIconSize)
    XCTAssertEqual(config.computedIconSize(highlighted: true), config.defaultIconSize - config.spacing)

    config.iconSize = 80

    XCTAssertEqual(config.computedIconSize(highlighted: false), config.iconSize)
    XCTAssertEqual(config.computedIconSize(highlighted: true), (config.iconSize ?? config.defaultIconSize) - config.spacing)
  }

  func testComputedHighlightedIconSizeInBounds() {
    let config = ReactionSelectorConfig()

    XCTAssertEqual(config.computedHighlightedIconSizeInBounds(CGRect(x: 0, y: 0, width: 100, height: 20), reactionCount: 4), 100 - config.defaultIconSize * 3)
  }

  func testComputedIconFrameAtIndex() {
    let config = ReactionSelectorConfig()

    let bounds = ReactionSelector().boundsToFit()

    let f1 = config.computedIconFrameAtIndex(0, in: bounds, reactionCount: 6, highlightedIndex: nil)

    XCTAssertEqual(f1, CGRect(x: config.spacing, y: config.spacing, width: config.defaultIconSize, height: config.defaultIconSize))

    let f2                        = config.computedIconFrameAtIndex(0, in: bounds, reactionCount: 6, highlightedIndex: 0)
    let selectedIconSize: CGFloat = 82

    XCTAssertEqual(f2, CGRect(x: 0, y: bounds.height - selectedIconSize - config.spacing, width: selectedIconSize, height: selectedIconSize))

    let f3                  = config.computedIconFrameAtIndex(0, in: bounds, reactionCount: 6, highlightedIndex: 2)
    let highlightedIconSize = config.computedIconSize(highlighted: true)

    XCTAssertEqual(f3, CGRect(x: config.spacing, y: config.spacing * 2, width: highlightedIconSize, height: highlightedIconSize))

    let f4 = config.computedIconFrameAtIndex(4, in: bounds, reactionCount: 6, highlightedIndex: 2)

    XCTAssertEqual(f4, CGRect(x: 202, y: config.spacing * 2, width: highlightedIconSize, height: highlightedIconSize))
  }

  func testComputedBounds() {
    let config = ReactionSelectorConfig()

    let bounds = ReactionSelector().boundsToFit()
    
    XCTAssertEqual(config.computedBounds(bounds, highlighted: false), bounds)
    XCTAssertEqual(config.computedBounds(bounds, highlighted: true), CGRect(x: 0, y: config.spacing, width: bounds.width, height: bounds.height - config.spacing))
  }
}
