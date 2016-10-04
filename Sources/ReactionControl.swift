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

import UIKit

public class ReactionControl: UIControl {
  // MARK: - Initializing a ReactionSelect Object

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupAndUpdate()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    setupAndUpdate()
  }

  // MARK: - Laying out Subviews

  public override func layoutSubviews() {
    super.layoutSubviews()

    update()
  }

  public override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()

    update()
  }

  // MARK: - Building Object

  func setup() {

  }

  final func setupAndUpdate() {
    setup()
    update()
  }

  // MARK: - Updating Object State

  func update() {
  }
}
