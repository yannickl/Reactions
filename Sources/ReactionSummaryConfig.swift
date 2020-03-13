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
 The reaction summary configuration object.
 */
public final class ReactionSummaryConfig: Configurable {
  /**
   The builder block.
   The block gives a reference of receiver you can configure.
   */
  public typealias ConfigurableBlock = (ReactionSummaryConfig) -> Void

  /// The spacing between the icons and the text.
  public var spacing: CGFloat = 8

  /// The marging between the icon and border.
  public var iconMarging: CGFloat = 2

  /// The font of the text.
  public var font: UIFont! = UIFont(name: "HelveticaNeue", size: 12)

  /// The color of the text.
  public var textColor: UIColor! = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
    
  /// The color of the border icon.
  public var iconBorderColor: UIColor! = UIColor.white
      
  /// The width of the border icon.
  public var iconBorderWidth: CGFloat = 2
    
  /**
     A Boolean value to round or not each icon.
       
     The default value is true.
  */
  public var isIconRounded: Bool = true

  /**
   The technique to use for aligning the icon and the text.

   The default value of this property is left.
   */
  public var alignment: ReactionAlignment = .left

  /**
   A Boolean value that indicates whether the summary should aggregate the reactions into one total indicator.

   The default value is true.
  */
  public var isAggregated: Bool = true

  // MARK: - Initializing a Reaction Summary

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
