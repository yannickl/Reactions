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

public final class ReactionSummary: ReactionControl {
  private let textLabel: UILabel            = Components.reactionSummary.facebookSummaryLabel()
  private var reactionIconLayers: [CALayer] = []

  private let spacing: CGFloat = 8

  public var font: UIFont! {
    get { return textLabel.font }
    set {
      textLabel.font = newValue

      update()
    }
  }

  public var text: String? {
    get { return textLabel.text }
    set {
      textLabel.text = newValue

      update()
    }
  }

  /**
   The technique to use for aligning the icon and the text.

   The default value of this property is left.
   */
  public var alignment: ReactionAlignment = .left {
    didSet { update() }
  }

  public var reactions: [Reaction] = [] {
    didSet { setupAndUpdate() }
  }

  // MARK: - Building Object

  override func setup() {
    gestureRecognizers?.forEach {
      removeGestureRecognizer($0)
    }

    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReactionSummary.tapAction)))

    textLabel.removeFromSuperview()
    reactionIconLayers.forEach { $0.removeFromSuperlayer() }

    reactionIconLayers = reactions.uniq().map { Components.reactionSummary.reactionIcon(option: $0) }

    for index in 0 ..< reactionIconLayers.count {
      let iconLayer           = reactionIconLayers[reactionIconLayers.count - 1 - index]
      iconLayer.masksToBounds = true
      iconLayer.borderWidth   = 1
      iconLayer.borderColor   = UIColor.white.cgColor

      layer.addSublayer(iconLayer)
    }

    addSubview(textLabel)
  }

  // MARK: - Updating Object State

  override func update() {
    let textSize   = textLabel.sizeThatFits(CGSize(width: bounds.width, height: bounds.height))
    let iconSize   = min(bounds.height, textSize.height + 4)
    let iconWidth  = (iconSize - 3) * CGFloat(reactionIconLayers.count) + spacing
    let margin     = (bounds.width - iconWidth - textSize.width) / 2

    for (index, l) in reactionIconLayers.enumerated() {
      let x: CGFloat

      switch alignment {
      case .left: x = (iconSize - 3) * CGFloat(index)
      case .right: x = bounds.width - iconSize - (iconSize - 3) * CGFloat(index)
      case .centerLeft: x = margin + (iconSize - 3) * CGFloat(index)
      case .centerRight: x = bounds.width - iconSize - (iconSize - 3) * CGFloat(index) - margin
      }

      l.frame        = CGRect(x: x, y: (bounds.height - iconSize) / 2, width: iconSize, height: iconSize)
      l.cornerRadius = iconSize / 2
    }

    let textX: CGFloat

    switch alignment {
    case .left: textX = iconWidth
    case .right: textX = bounds.width - iconWidth - textSize.width
    case .centerLeft: textX = margin + iconWidth
    case .centerRight: textX = bounds.width - iconWidth - textSize.width - margin
    }

    textLabel.frame = CGRect(x: textX, y: 0, width: textSize.width, height: bounds.height)
  }

  // MARK: - Responding to Gesture Events

  func tapAction(_ gestureRecognizer: UITapGestureRecognizer) {
    sendActions(for: .touchUpInside)
  }
}
