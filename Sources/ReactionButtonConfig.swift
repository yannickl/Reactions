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
 The reaction button configuration object.
 */
public final class ReactionButtonConfig: Configurable {
  /**
   The builder block.
   The block gives a reference of receiver you can configure.
   */
  public typealias ConfigurableBlock = (ReactionButtonConfig) -> Void

  /// The spacing between the icon and the text.
  public var spacing: CGFloat     = 8

  /// The marging between the icon and border.
  public var iconMarging: CGFloat = 4

  /// The font of the text.
  public var font: UIFont! = UIFont(name: "HelveticaNeue", size: 16)

  /// The color of the text (and image) when no reaction is selected.
  public var neutralTintColor: UIColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)

  /**
   The technique to use for aligning the icon and the text.

   The default value of this property is left.
   */
  public var alignment: ReactionAlignment = .left

  // MARK: - Initializing a Reaction Button

  // Initialize a configurable with default values.
  init() {}

  /**
   Initialize a configurable with default values.

   - Parameter block: A configurable block to configure itself.
   */
  public init(block: ConfigurableBlock) {
    block(self)
  }
}
