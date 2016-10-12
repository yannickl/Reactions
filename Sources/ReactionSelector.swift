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
 A `ReactionSelector` object is a horizontal control made of multiple reactions, each reaction functioning as a discrete button. A select control affords a compact means to group together a number of reactions.
 
 The `ReactionSelector` class declares a property to control its selected reaction. When the user manipulates the selector a `valueChanged` event is generated, which results in the control (if properly configured) sending an action message.

 The `ReactionSelector` object automatically resizes reactions using the `iconSize` and `spacing` values defined in the `config` property.
 
 You can configure/skin the button using a `ReactionSelectorConfig`.
 */
public final class ReactionSelector: UIReactionControl {
  private var reactionIconLayers: [CALayer] = []
  private var reactionLabels: [UILabel]     = []
  private let backgroundLayer               = Components.reactionSelect.backgroundLayer()
  private var _reactions: [Reaction]        = Reaction.facebook.all

  /**
   The reactions available in the selector.
   */
  public var reactions: [Reaction] {
    get { return _reactions }
    set { setReactions(newValue, sizeToFit: false) }
  }

  /**
   Sets the selector reactions and update the frame to fit if necessary.
   
   - Parameter reactions: The reactions to choose in the selector.
   - Parameter sizeToFit: Flag to tell the receiver to update its frame to fit. False by default.
   */
  public func setReactions(_ reactions: [Reaction], sizeToFit: Bool = false) {
    _reactions = reactions

    if sizeToFit {
      frame = boundsToFit()
    }

    setupAndUpdate()
  }

  /// The feedback delegate.
  public weak var feedbackDelegate: ReactionFeedbackDelegate?

  /// The selector feedback state.
  public internal(set) var feedback: ReactionFeedback? {
    didSet {
      if oldValue != feedback { feedbackDelegate?.reactionFeedbackDidChanged(feedback) }
    }
  }

  /**
   The reaction selector configuration.
   */
  public var config = ReactionSelectorConfig()

  // MARK: - Managing Internal State

  private var stateHighlightedReactionIndex: Int?
  private var stateSelectedReaction: Reaction?

  /// The selected reaction.
  public var selectedReaction: Reaction? {
    get { return stateSelectedReaction }
    set {
      if let reaction = newValue, config.stickyReaction {
        stateHighlightedReactionIndex = reactions.index(of: reaction)
      }
      else {
        stateHighlightedReactionIndex = nil
      }

      stateSelectedReaction = newValue

      setNeedsLayout()
    }
  }

  // MARK: - Building Object

  override func setup() {
    reactionIconLayers.forEach { $0.removeFromSuperlayer() }
    reactionLabels.forEach { $0.removeFromSuperview() }

    reactionIconLayers = reactions.map { Components.reactionSelect.reactionIcon(option: $0) }
    reactionLabels     = reactions.map { Components.reactionSelect.reactionLabel(option: $0, height: config.spacing * 4) }

    if backgroundLayer.superlayer == nil {
      addGestureRecognizer(UILongPressGestureRecognizer().build {
        $0.addTarget(self, action: #selector(ReactionSelector.longPressAction))
        $0.minimumPressDuration = 0
      })

      let backgroundBounds = boundsToFit()
      backgroundLayer.path = UIBezierPath(roundedRect: backgroundBounds, cornerRadius: backgroundBounds.height / 2).cgPath

      layer.addSublayer(backgroundLayer)
    }

    reactionIconLayers.forEach { layer.addSublayer($0) }
    reactionLabels.forEach { addSubview($0) }
  }

  // MARK: - Updating Object State

  override func update() {
    let backgroundBounds = config.computedBounds(bounds, highlighted: stateHighlightedReactionIndex != nil)
    let backgroundPath   = UIBezierPath(roundedRect: backgroundBounds, cornerRadius: backgroundBounds.height / 2).cgPath

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

    for index in 0 ..< reactionIconLayers.count {
      updateReactionAtIndex(index, highlighted: stateHighlightedReactionIndex == index)
    }

    CATransaction.commit()
  }

  private func updateReactionAtIndex(_ index: Int, highlighted isHighlighted: Bool) {
    let icon: CALayer                    = reactionIconLayers[index]
    let label: UILabel                   = reactionLabels[index]
    let labelAlpha: CGFloat              = isHighlighted ? 1 : 0
    let labelTranform: CGAffineTransform = isHighlighted ? .identity : CGAffineTransform(scaleX: 0.5, y: 0.5)

    icon.frame = config.computedIconFrameAtIndex(index, in: bounds, reactionCount: reactions.count, highlightedIndex: stateHighlightedReactionIndex)

    UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: .curveEaseIn, animations: { [unowned self] in
      label.alpha     = labelAlpha
      label.transform = labelTranform
      label.center    = CGPoint(x: icon.frame.midX, y: icon.frame.minY - label.bounds.height / 2 - self.config.spacing)
      }, completion: nil)
  }

  // MARK: - Configuring the Resizing Behavior

  /**
   Returns the computed receiver view bounds so it just encloses its reactions.

   Call this method when you want to get the minimum bounds the current view needs to fit.

   - Returns: The minimum view bounds the receiver should have.
   */
  func boundsToFit() -> CGRect {
    let iconSize = config.computedIconSize(highlighted: false)

    return CGRect(x: 0, y: 0, width: CGFloat(reactions.count) * (iconSize + config.spacing) + config.spacing, height: iconSize + config.spacing * 2)
  }

  // MARK: - Responding to Gesture Events

  func longPressAction(_ gestureRecognizer: UIGestureRecognizer) {
    let location    = gestureRecognizer.location(in: self)
    let touchIndex  = optionIndexFromPoint(location)
    let needsUpdate = touchIndex != stateHighlightedReactionIndex

    if needsUpdate {
      stateHighlightedReactionIndex = touchIndex
      stateSelectedReaction         = touchIndex == nil ? nil : reactions[touchIndex!]

      setNeedsLayout()

      sendActions(for: .valueChanged)
    }

    if gestureRecognizer.state == .began {
      feedback = .slideFingerAcross
    }

    if gestureRecognizer.state == .changed {
      if needsUpdate {
        let isInside = isPointInsideExtendedBounds(location)

        feedback = isInside ? .slideFingerAcross: .releaseToCancel
        
        sendActions(for: isInside ? .touchDragEnter : .touchDragExit)
      }
    }
    else if gestureRecognizer.state != .changed {
      if gestureRecognizer.state == .ended && !config.stickyReaction {
        stateHighlightedReactionIndex = nil
      }

      update()

      if gestureRecognizer.state == .ended {
        feedback = nil

        sendActions(for: isPointInsideExtendedBounds(location) ? .touchUpInside : .touchUpOutside)
      }
    }
  }

  // MARK: - Locating Points

  private func isPointInsideExtendedBounds(_ location: CGPoint) -> Bool {
    return CGRect(x: bounds.origin.x, y: -bounds.height, width: bounds.width, height: bounds.height * 3).contains(location)
  }

  private func optionIndexFromPoint(_ location: CGPoint) -> Int? {
    if isPointInsideExtendedBounds(location) {
      for (index, o) in reactionIconLayers.enumerated() {
        if o.frame.origin.x <= location.x && location.x <= (o.frame.origin.x + o.frame.width) {
          return index
        }
      }
    }

    return nil
  }
}
