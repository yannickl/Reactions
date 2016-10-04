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

@IBDesignable
public final class ReactionSelect: ReactionControl {
  public var options: [Reaction] = Reaction.facebook {
    didSet { setupAndUpdate() }
  }

  private var space: CGFloat = 6
  private var optionIconLayers: [CALayer] = []
  private var optionLabels: [UILabel]     = []
  private let backgroundLayer = ComponentBuilder.ReactionSelect.backgroundLayer

  // MARK: - Managing Internal State

  private var highlightedReactionIndex: Int? {
    didSet {
      if oldValue != highlightedReactionIndex {
        sendActions(for: .valueChanged)

        setNeedsLayout()
      }
    }
  }

  public var selectedReaction: Reaction? {
    guard let index = highlightedReactionIndex else { return nil }

    return options[index]
  }

  // MARK: - Building Object

  override func setup() {
    optionIconLayers.forEach { $0.removeFromSuperlayer() }
    optionLabels.forEach { $0.removeFromSuperview() }

    optionIconLayers = options.map { ComponentBuilder.ReactionSelect.optionIcon(option: $0) }
    optionLabels     = options.map { ComponentBuilder.ReactionSelect.optionLabel(option: $0, height: space * 4) }

    if backgroundLayer.superlayer == nil {
      layer.addSublayer(backgroundLayer)
    }

    optionIconLayers.forEach { layer.addSublayer($0) }
    optionLabels.forEach { addSubview($0) }
  }

  // MARK: - Updating Object State

  override func update() {
    let optionCount      = CGFloat(options.count)
    var backgroundBounds = bounds

    if highlightedReactionIndex != nil {
      backgroundBounds = CGRect(x: 0, y: space, width: bounds.width, height: bounds.height - space)
    }

    let backgroundPath      = UIBezierPath(roundedRect: backgroundBounds, cornerRadius: backgroundBounds.height / 2).cgPath
    let iconSize            = backgroundBounds.height - 2 * space
    let highlightedIconSize = bounds.width - (bounds.height - 2 * space) * (optionCount - 1)

    CATransaction.begin()
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    CATransaction.setCompletionBlock { [weak self] in
      self?.backgroundLayer.path = backgroundPath
    }

    let pathAnimation                   = CABasicAnimation(keyPath: "path")
    pathAnimation.toValue               = backgroundPath
    pathAnimation.fillMode              = kCAFillModeBoth
    pathAnimation.isRemovedOnCompletion = false
    backgroundLayer.add(pathAnimation, forKey: "morhingPath")

    updateOptionsWithSize((iconSize, highlightedIconSize), margin: space)

    CATransaction.commit()
  }

  private func updateOptionsWithSize(_ size: (normal: CGFloat, highlighted: CGFloat), margin: CGFloat) {
    for (index, icon) in optionIconLayers.enumerated() {
      let fi    = CGFloat(index)
      let label = optionLabels[index]
      let labelAlpha: CGFloat
      let labelTranform: CGAffineTransform

      if let highlightedIndex = highlightedReactionIndex, index >= highlightedIndex {
        if index == highlightedIndex {
          labelAlpha    = 0.7
          labelTranform = .identity
          icon.frame    = CGRect(x: (size.normal + space) * fi, y: bounds.height - size.highlighted - margin, width: size.highlighted, height: size.highlighted)
        }
        else {
          labelAlpha    = 0
          labelTranform = CGAffineTransform(scaleX: 0.5, y: 0.5)
          icon.frame    = CGRect(x: (size.normal + space) * (fi - 1) + size.highlighted, y: margin * 2, width: size.normal, height: size.normal)
        }
      }
      else {
        labelAlpha    = 0
        labelTranform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        icon.frame    = CGRect(x: space + (size.normal + space) * fi, y: margin, width: size.normal, height: size.normal)
      }

      UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: .curveEaseIn, animations: {
        label.transform = labelTranform
        label.alpha     = labelAlpha
        label.center    = CGPoint(x: icon.frame.midX, y: icon.frame.minY - label.bounds.height / 2 - margin)
        }, completion: nil)
    }
  }

  // MARK: - Responding to Touch Events
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }

    highlightedReactionIndex = optionIndexFromTouch(touch)
  }

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }

    highlightedReactionIndex = optionIndexFromTouch(touch)
  }

  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      highlightedReactionIndex = nil

      return
    }

    highlightedReactionIndex = optionIndexFromTouch(touch)
  }

  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    highlightedReactionIndex = nil
  }

  private func optionIndexFromTouch(_ touch: UITouch) -> Int? {
    let point          = touch.location(in: self)
    let extendedBounds = CGRect(x: bounds.origin.x, y: -bounds.height, width: bounds.width, height: bounds.height * 3)

    if extendedBounds.contains(point) {
      for (index, o) in optionIconLayers.enumerated() {
        if o.frame.origin.x <= point.x && point.x <= (o.frame.origin.x + o.frame.width) {
          return index
        }
      }
    }

    return nil
  }
}
