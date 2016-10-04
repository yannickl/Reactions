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

  static let facebook: [Reaction] = [
    Reaction(id: "like", title: "J'aime", color: UIColor(red: 0.29, green: 0.54, blue: 0.95, alpha: 1), icon: UIImage(named: "like")!, alternativeIcon: UIImage(named: "like-template")?.withRenderingMode(.alwaysTemplate)),
    Reaction(id: "love", title: "J'adore", color: UIColor(red: 0.93, green: 0.23, blue: 0.33, alpha: 1), icon: UIImage(named: "love")!),
    Reaction(id: "haha", title: "Haha", color: UIColor(red: 0.99, green: 0.84, blue: 0.38, alpha: 1), icon: UIImage(named: "haha")!),
    Reaction(id: "wow", title: "Wouah", color: UIColor(red: 0.99, green: 0.84, blue: 0.38, alpha: 1), icon: UIImage(named: "wow")!),
    Reaction(id: "sad", title: "Triste", color: UIColor(red: 0.99, green: 0.84, blue: 0.38, alpha: 1), icon: UIImage(named: "sad")!),
    Reaction(id: "angry", title: "Grrr", color: UIColor(red: 0.96, green: 0.37, blue: 0.34, alpha: 1), icon: UIImage(named: "angry")!)
  ]
}

extension Reaction: Equatable {
  public static func ==(lhs: Reaction, rhs: Reaction) -> Bool {
    return lhs.id == rhs.id
  }
}

extension Reaction: CustomStringConvertible {
  public var description: String {
    return "<Reaction id=\(id)>"
  }
}
