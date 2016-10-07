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
 A reaction structure is 
 
 The `Reaction` struct implements a reaction on a `ReactionSelect` object. A tab bar operates strictly in radio mode, where one item is selected at a time—tapping a tab bar item toggles the view above the tab bar. You can also specify a badge value on the tab bar item for adding additional visual information—for example, the Messages app uses a badge on the item to show the number of new messages. This class also provides a number of system defaults for creating items.
 */
public struct Reaction {
  public let id: String
  public let title: String
  public let color: UIColor
  public let icon: UIImage
  public let alternativeIcon: UIImage?

  public init(id: String, title: String, color: UIColor, icon: UIImage, alternativeIcon: UIImage? = nil) {
    self.id              = id
    self.title           = title
    self.color           = color
    self.icon            = icon
    self.alternativeIcon = alternativeIcon
  }
}

extension Reaction: Equatable {
  public static func ==(lhs: Reaction, rhs: Reaction) -> Bool {
    return lhs.id == rhs.id
  }
}

extension Reaction: Hashable {
  public var hashValue: Int {
    return id.hashValue
  }
}

extension Reaction: CustomStringConvertible {
  public var description: String {
    return "<Reaction id=\(id) title=\(title)>"
  }
}
