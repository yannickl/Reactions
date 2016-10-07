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

public final class ReactionSelectControlConfig {
  public typealias ReactionSelectControlConfigBlock = (ReactionSelectControlConfig) -> Void

  public var spacing: CGFloat = 6
  public var iconSize: CGFloat? = nil
  public var stickyReaction: Bool = false

  init() {}

  public init(block: ReactionSelectControlConfigBlock) {
    block(self)
  }

  // MARK: - Convenient Methods

  /// Returns the icon size either in normal or highlighted mode
  final func computedIconSize(highlighted isHighlighted: Bool) -> CGFloat {
    let size = iconSize ?? 40

    return isHighlighted ? size - spacing : size
  }

  /// Returns the highlighted icon size
  final func computedHighlightedIconSizeInBounds(_ bounds: CGRect, reactionCount: Int) -> CGFloat {
    let iconSize = computedIconSize(highlighted: true) + spacing

    return bounds.width - iconSize * CGFloat(reactionCount - 1)
  }

  /// Returns the icon frame
  final func computedIconFrameAtIndex(_ index: Int, in bounds: CGRect, reactionCount: Int, highlightedIndex: Int?) -> CGRect {
    let isHighlighted = highlightedIndex != nil
    let fi            = CGFloat(index)
    let topMargin     = isHighlighted ? spacing * 2 : spacing
    let iconSize      = computedIconSize(highlighted: isHighlighted)

    if let hi = highlightedIndex, index == hi {
      let highlightedSize = computedHighlightedIconSizeInBounds(bounds, reactionCount: reactionCount)

      return CGRect(x: (iconSize + spacing) * fi, y: bounds.height - highlightedSize - spacing, width: highlightedSize, height: highlightedSize)
    }
    else if let hi = highlightedIndex, index > hi {
      let highlightedSize = computedHighlightedIconSizeInBounds(bounds, reactionCount: reactionCount)

      return CGRect(x: (iconSize + spacing) * (fi - 1) + highlightedSize, y: topMargin, width: iconSize, height: iconSize)
    }
    else {
      return CGRect(x: spacing + (iconSize + spacing) * fi, y: topMargin, width: iconSize, height: iconSize)
    }
  }

  /// Returns the preferred bounds either in normal or highlighted mode
  final func computedBounds(_ bounds: CGRect, highlighted: Bool) -> CGRect {
    return highlighted ? CGRect(x: 0, y: spacing, width: bounds.width, height: bounds.height - spacing) : bounds
  }
}
