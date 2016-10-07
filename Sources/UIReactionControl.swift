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

/**
 The `UIReactionControl` class implements common behavior for reaction elements. It mainly defines two methods:
 
 - `setup`: Manage the view hierarchy by adding and/or removing elements.
 - `update`: Layout the view hierarchy and update state.
 
 You should override these methods if you subclass the `UIReactionControl`.
 */
public class UIReactionControl: UIControl {
  // MARK: - Initializing a ReactionSelect Object

  /// Initializes and returns a newly allocated view object with the specified frame rectangle.
  public override init(frame: CGRect) {
    super.init(frame: frame)

    setupAndUpdate()
  }

  /// Returns an object initialized from data in a given unarchiver.
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    setupAndUpdate()
  }

  // MARK: - Laying out Subviews

  /// Lays out subviews.
  public override func layoutSubviews() {
    super.layoutSubviews()

    update()
  }

  /// Called when a designable object is created in Interface Builder.
  public override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()

    update()
  }

  // MARK: - Building Object

  /// Setup the view hierarchy
  func setup() {}

  /// Call the setup then the update method
  final func setupAndUpdate() {
    setup()

    if superview != nil {
      update()
    }
  }

  // MARK: - Updating Object State

  /// Update the state and layout the view hierarchy
  func update() {}
}
