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

import CoreText
import UIKit

fileprivate extension CATextLayer {
  func layoutWithConfig(_ config: ReactionSummaryConfig) {
    font            = config.font
    fontSize        = config.font.pointSize
    foregroundColor = config.textColor.cgColor
  }
}

/// Convenience layer to draw the summary icon and labels
final class CAReactionSummaryLayer: CALayer {
  private var reactionsLayers: [(CALayer, CATextLayer)] = [] {
    didSet {
      for (iconLayer, textLayer) in oldValue {
        iconLayer.removeFromSuperlayer()
        textLayer.removeFromSuperlayer()
      }

      for index in 0 ..< reactionsLayers.count {
        let (iconLayer, textLayer) = reactionsLayers[reactionsLayers.count - 1 - index]

        addSublayer(iconLayer)
        addSublayer(textLayer)
      }
    }
  }

  private var reactionPairs: [(Reaction, Int)] = [] {
    didSet {
      reactionsLayers = reactionPairs.map({
        let iconLayer           = CALayer()
        iconLayer.contents      = $0.0.icon.cgImage
        iconLayer.masksToBounds = true
        iconLayer.borderColor   = UIColor.white.cgColor
        iconLayer.borderWidth   = 2
        iconLayer.contentsScale = UIScreen.main.scale

        let textLayer           = CATextLayer()
        textLayer.string        = "\($0.1)"
        textLayer.contentsScale = UIScreen.main.scale

        return (iconLayer, textLayer)
      })
    }
  }

  var reactions: [Reaction] = [] {
    didSet {
      reactionPairs = reactions.uniq().map({ reaction in
        let reactionCount = reactions.filter({ $0 == reaction }).count

        return (reaction, reactionCount)
      })
    }
  }

  var config: ReactionSummaryConfig = ReactionSummaryConfig() {
    didSet {
      setNeedsDisplay()
    }
  }

  // MARK: - Providing the Layer’s Content
  
  override func draw(in ctx: CGContext) {
    super.draw(in: ctx)

    for (index, (iconLayer, textLayer)) in reactionsLayers.enumerated() {
      let rect = reactionFrameAt(index)

      textLayer.isHidden = config.isAggregated

      updateIconLayer(iconLayer, textLayer: textLayer, in: rect)
    }
  }

  private func updateIconLayer(_ iconLayer: CALayer, textLayer: CATextLayer, in rect: CGRect) {
    var iconFrame        = rect
    iconFrame.size.width = iconFrame.height

    let textSize         = sizeForText(textLayer.string as! String)
    var textFrame        = rect
    textFrame.origin.y   += (rect.height - textSize.height) / 2
    textFrame.size.width = textFrame.width - iconFrame.height

    switch config.alignment {
    case .left, .centerLeft:
      textFrame.origin.x += iconFrame.width
    case .right, .centerRight:
      textFrame.origin.x = bounds.width - textFrame.origin.x - rect.width
      iconFrame.origin.x = bounds.width - iconFrame.origin.x - rect.width + textFrame.width
    }

    iconLayer.frame        = iconFrame
    iconLayer.cornerRadius = iconFrame.height / 2

    textLayer.frame = textFrame
    textLayer.layoutWithConfig(config)
  }

  func sizeToFit() -> CGSize {
    let lastReactionFrame = reactionFrameAt(reactionPairs.count - 1)
    let width: CGFloat    = lastReactionFrame.origin.x + lastReactionFrame.width

    return CGSize(width: width, height: bounds.height)
  }

  private func reactionFrameAt(_ index: Int) -> CGRect {
    guard index >= 0 else { return .zero }

    let iconHeight = bounds.height - config.iconMarging * 2

    guard !config.isAggregated else {
      return CGRect(x: (iconHeight - 3) * CGFloat(index), y: config.iconMarging, width: iconHeight, height: iconHeight)
    }

    let previousReactionFrame = reactionFrameAt(index - 1)
    let reactionPair          = reactionPairs[index]

    let textSize = sizeForText("\(reactionPair.1)")
    var offsetX  = previousReactionFrame.origin.x + previousReactionFrame.width
    offsetX      = offsetX > 0 ? offsetX + config.spacing : 0

    return CGRect(x: offsetX, y: config.iconMarging, width: iconHeight + textSize.width, height: iconHeight)
  }

  private func sizeForText(_ text: String) -> CGSize {
    let attributedText = NSAttributedString(string: text, attributes: [
      NSAttributedString.Key.font: config.font!,
      NSAttributedString.Key.foregroundColor: config.textColor!
      ])

    return attributedText.size()
  }
}
