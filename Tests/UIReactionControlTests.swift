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

class UIReactionControlTests: XCTestCase {
  func testUIReactionControlInit() {
    let control = UIReactionControl()

    XCTAssertNotNil(control)
    XCTAssertEqual(control.frame, .zero)
  }

  func testUIReactionControlWithFrame() {
    let frame   = CGRect(x: 50, y: 50, width: 300, height: 20)
    let control = UIReactionControl(frame: frame)

    XCTAssertNotNil(control)
    XCTAssertEqual(control.frame, frame)

    control.update()
  }

  func testUIReactionControlWithCoder() {
    let control = Bundle(for: UIReactionControlTests.self).loadNibNamed("UIReactionControlTest", owner: self, options: nil)

    XCTAssertNotNil(control)
  }

  func testUpdateCall() {
    class CustomControl: UIReactionControl {
      var expectation: XCTestExpectation?

      override func update() {
        expectation?.fulfill()
      }
    }

    let control = CustomControl()
    let expect  = expectation(description: "update")

    control.expectation = expect
    control.layoutSubviews()

    waitForExpectations(timeout: 0.1, handler: nil)

    let expect2 = expectation(description: "update")

    control.expectation = expect2
    control.prepareForInterfaceBuilder()

    waitForExpectations(timeout: 0.1, handler: nil)

    let dummyView = UIView()
    dummyView.addSubview(control)
    
    let expect3   = expectation(description: "update")

    control.expectation = expect3
    control.setupAndUpdate()

    waitForExpectations(timeout: 0.1, handler: nil)
  }
}
