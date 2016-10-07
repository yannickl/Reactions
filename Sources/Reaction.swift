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
 The `Reaction` struct defines several attributes like the title, the icon or the color of the reaction.

 A `Reaction` can be used with objects like `ReactionSelector`, `ReactionButton` and `ReactionSummary`.
 */
public struct Reaction {
  /// The reaction's identifier.
  public let id: String

  /// The reaction's title.
  public let title: String

  /// The reaction's color.
  public let color: UIColor

  /// The reaction's icon image.
  public let icon: UIImage

  /**
   The reaction's alternative icon image.
   
   The alternative icon is only used by the `ReactionButton`. It tries to display the alternative as icon and if it fails it uses the `icon`.
   */
  public let alternativeIcon: UIImage?

  /**
   Creates and returns a new reaction using the specified properties.

   - Parameter id: The reaction's identifier.
   - Parameter title: The reaction's title.
   - Parameter color: The reaction's color.
   - Parameter icon: The reaction's icon image.
   - Parameter alternativeIcon: The reaction's alternative icon image.
   - Returns: Newly initialized reaction with the specified properties.
   */
  public init(id: String, title: String, color: UIColor, icon: UIImage, alternativeIcon: UIImage? = nil) {
    self.id              = id
    self.title           = title
    self.color           = color
    self.icon            = icon
    self.alternativeIcon = alternativeIcon
  }
}

extension Reaction: Equatable {
  /// Returns a Boolean value indicating whether two values are equal.
  public static func ==(lhs: Reaction, rhs: Reaction) -> Bool {
    return lhs.id == rhs.id
  }
}

extension Reaction: Hashable {
  /// The hash value.
  public var hashValue: Int {
    return id.hashValue
  }
}

extension Reaction: CustomStringConvertible {
  /// A textual representation of this instance.
  public var description: String {
    return "<Reaction id=\(id) title=\(title)>"
  }
}
