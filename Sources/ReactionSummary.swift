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
 A `ReactionSummary` component aims to display a list of reactions as a thumbnail associate to a text description.
 
 You can configure/skin the summary using a `ReactionSummaryConfig`.
 */
public final class ReactionSummary: UIReactionControl {
  private let textLabel: UILabel            = UILabel()
  private var reactionIconLayers: [CALayer] = []

  /**
   The reaction summary configuration.
   */
  public var config: ReactionSummaryConfig = ReactionSummaryConfig() {
    didSet { setupAndUpdate() }
  }

  /**
   The reactions to summarize.
   */
  public var reactions: [Reaction] = [] {
    didSet { setupAndUpdate() }
  }

  /**
   The text displayed by the reaction summary.

   This string is nil by default.
   */
  public var text: String? {
    get { return textLabel.text }
    set {
      textLabel.text = newValue

      update()
    }
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
    textLabel.font      = config.font
    textLabel.textColor = config.textColor

    var textSize  = textLabel.sizeThatFits(CGSize(width: bounds.width, height: bounds.height))

    if textSize.height == 0 {
      textSize.height = bounds.height
    }

    let iconSize  = min(bounds.height, textSize.height + 4)
    let iconWidth = (iconSize - 3) * CGFloat(reactionIconLayers.count) + config.spacing
    let margin    = (bounds.width - iconWidth - textSize.width) / 2

    for index in 0 ..< reactionIconLayers.count {
      updateIconAtIndex(index, with: iconSize, margin: margin)
    }

    let textX: CGFloat

    switch config.alignment {
    case .left: textX = iconWidth
    case .right: textX = bounds.width - iconWidth - textSize.width
    case .centerLeft: textX = margin + iconWidth
    case .centerRight: textX = bounds.width - iconWidth - textSize.width - margin
    }

    textLabel.frame = CGRect(x: textX, y: 0, width: textSize.width, height: bounds.height)
  }

  private func updateIconAtIndex(_ index: Int, with size: CGFloat, margin: CGFloat) {
    let x: CGFloat
    let layer = reactionIconLayers[index]

    switch config.alignment {
    case .left: x = (size - 3) * CGFloat(index)
    case .right: x = bounds.width - size - (size - 3) * CGFloat(index)
    case .centerLeft: x = margin + (size - 3) * CGFloat(index)
    case .centerRight: x = bounds.width - size - (size - 3) * CGFloat(index) - margin
    }

    layer.frame        = CGRect(x: x, y: (bounds.height - size) / 2, width: size, height: size)
    layer.cornerRadius = size / 2
  }

  // MARK: - Responding to Gesture Events

  func tapAction(_ gestureRecognizer: UITapGestureRecognizer) {
    sendActions(for: .touchUpInside)
  }
}
