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

public final class ReactionSelect: ReactionControl {
  public var options: [Reaction] = Reaction.facebook {
    didSet { setupAndUpdate() }
  }

  private var space: CGFloat = 6
  private var optionIconLayers: [CALayer] = []
  private var optionLabels: [UILabel]     = []
  private let backgroundLayer = Component.ReactionSelect.backgroundLayer
  private lazy var press: UILongPressGestureRecognizer = UILongPressGestureRecognizer().build {
    $0.addTarget(self, action: #selector(ReactionSelect.gestureAction))
    $0.minimumPressDuration = 0
  }

  public var stickyReaction: Bool = false

  // MARK: - Managing Internal State

  private var highlightedReactionIndex: Int? {
    didSet { setNeedsLayout() }
  }

  public var selectedReaction: Reaction? {
    guard let index = highlightedReactionIndex else { return nil }

    return options[index]
  }

  // MARK: - Building Object

  override func setup() {
    optionIconLayers.forEach { $0.removeFromSuperlayer() }
    optionLabels.forEach { $0.removeFromSuperview() }

    optionIconLayers = options.map { Component.ReactionSelect.optionIcon(option: $0) }
    optionLabels     = options.map { Component.ReactionSelect.optionLabel(option: $0, height: space * 4) }

    if backgroundLayer.superlayer == nil {
      addGestureRecognizer(press)

      layer.addSublayer(backgroundLayer)
    }

    optionIconLayers.forEach { layer.addSublayer($0) }
    optionLabels.forEach { addSubview($0) }
  }

  // MARK: - Updating Object State

  override func update() {
    let stickReaction    = (highlightedReactionIndex != nil && press.state != .ended) || (press.state == .ended && stickyReaction)
    let optionCount      = CGFloat(options.count)
    var backgroundBounds = bounds

    if stickReaction {
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

    let pathAnimation = CABasicAnimation(keyPath: "path").build {
      $0.toValue               = backgroundPath
      $0.fillMode              = kCAFillModeBoth
      $0.isRemovedOnCompletion = false
    }
    backgroundLayer.add(pathAnimation, forKey: "morhingPath")

    updateOptionsWithSize((iconSize, highlightedIconSize), sticky: stickReaction)

    CATransaction.commit()
  }

  private func updateOptionsWithSize(_ size: (normal: CGFloat, highlighted: CGFloat), sticky: Bool) {
    let topMargin = sticky ? space * 2 : space

    for (index, icon) in optionIconLayers.enumerated() {
      let fi            = CGFloat(index)
      let label         = optionLabels[index]
      var labelAlpha    = CGFloat(0)
      var labelTranform = CGAffineTransform(scaleX: 0.5, y: 0.5)

      if sticky, let highlightedIndex = highlightedReactionIndex, index >= highlightedIndex {
        if index == highlightedIndex {
          labelAlpha    = 0.7
          labelTranform = .identity
          icon.frame    = CGRect(x: (size.normal + space) * fi, y: bounds.height - size.highlighted - space, width: size.highlighted, height: size.highlighted)
        }
        else {
          icon.frame = CGRect(x: (size.normal + space) * (fi - 1) + size.highlighted, y: topMargin, width: size.normal, height: size.normal)
        }
      }
      else {
        icon.frame = CGRect(x: space + (size.normal + space) * fi, y: topMargin, width: size.normal, height: size.normal)
      }

      UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: .curveEaseIn, animations: { [unowned self] in
        label.transform = labelTranform
        label.alpha     = labelAlpha
        label.center    = CGPoint(x: icon.frame.midX, y: icon.frame.minY - label.bounds.height / 2 - self.space)
        }, completion: nil)
    }
  }

  // MARK: - Responding to Touch Events

  func gestureAction(_ gestureRecognizer: UIGestureRecognizer) {
    let location    = gestureRecognizer.location(in: self)
    let index       = optionIndexFromPoint(location)
    let needsUpdate = index != highlightedReactionIndex

    if needsUpdate {
      highlightedReactionIndex = index

      sendActions(for: .valueChanged)
    }

    switch gestureRecognizer.state {
    case .began:
      update()
    case .changed:
      if needsUpdate {
        sendActions(for: isPointInsideExtendedBounds(location) ? .touchDragEnter : .touchDragExit)
      }
    case .ended:
      update()

      sendActions(for: index == nil ? .touchUpOutside : .touchUpInside)
    default:
      break
    }
  }

  private func isPointInsideExtendedBounds(_ location: CGPoint) -> Bool {
    return CGRect(x: bounds.origin.x, y: -bounds.height, width: bounds.width, height: bounds.height * 3).contains(location)
  }

  private func optionIndexFromPoint(_ location: CGPoint) -> Int? {
    if isPointInsideExtendedBounds(location) {
      for (index, o) in optionIconLayers.enumerated() {
        if o.frame.origin.x <= location.x && location.x <= (o.frame.origin.x + o.frame.width) {
          return index
        }
      }
    }
    
    return nil
  }
}
