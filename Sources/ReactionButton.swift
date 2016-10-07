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

public final class ReactionButton: UIReactionControl {
  private let iconImageView: UIImageView = Components.reactionButton.facebookLikeIcon()
  private let titleLabel: UILabel        = Components.reactionButton.facebookLikeLabel()
  private lazy var overlay: UIView       = UIView().build {
    $0.clipsToBounds   = false
    $0.backgroundColor = .clear
    $0.alpha           = 0

    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReactionButton.dismissOverlay)))
  }

  public override var isSelected: Bool {
    didSet { update() }
  }

  public var config: ReactionButtonConfig = ReactionButtonConfig() {
    didSet { update() }
  }

  public var reaction = Reaction.facebook.like {
    didSet { update() }
  }

  public var reactionSelectControl: ReactionSelectControl? {
    didSet { setupReactionSelect(old: oldValue) }
  }

  // MARK: - Building Object

  override func setup() {
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReactionButton.tapAction)))
    addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(ReactionButton.longPressAction)))

    addSubview(iconImageView)
    addSubview(titleLabel)
  }

  private func setupReactionSelect(old: ReactionSelectControl?) {
    if let reactionSelect = reactionSelectControl {
      overlay.addSubview(reactionSelect)
    }

    old?.removeFromSuperview()
    old?.removeTarget(self, action: #selector(ReactionButton.reactionTouchedInsideAction), for: .touchUpInside)
    old?.removeTarget(self, action: #selector(ReactionButton.reactionTouchedOutsideAction), for: .touchUpOutside)

    reaction = reactionSelectControl?.reactions.first ?? Reaction.facebook.like

    reactionSelectControl?.addTarget(self, action: #selector(ReactionButton.reactionTouchedInsideAction), for: .touchUpInside)
    reactionSelectControl?.addTarget(self, action: #selector(ReactionButton.reactionTouchedOutsideAction), for: .touchUpOutside)
  }

  // MARK: - Updating Object State

  override func update() {
    titleLabel.font = config.font

    let iconSize   = min(bounds.width - config.spacing, bounds.height) - config.iconMarging * 2
    let titleSize  = titleLabel.sizeThatFits(CGSize(width: bounds.width - iconSize, height: bounds.height))
    var iconFrame  = CGRect(x: 0, y: (bounds.height - iconSize) / 2, width: iconSize, height: iconSize)
    var titleFrame = CGRect(x: iconSize + config.spacing, y: 0, width: titleSize.width, height: bounds.height)

    if config.alignment == .right {
      iconFrame.origin.x  = bounds.width - iconSize
      titleFrame.origin.x = bounds.width - iconSize - config.spacing - titleSize.width
    }
    else if config.alignment == .centerLeft || config.alignment == .centerRight {
      let emptyWidth = bounds.width - iconFrame.width - titleLabel.bounds.width - config.spacing

      if config.alignment == .centerLeft {
        iconFrame.origin.x  = emptyWidth / 2
        titleFrame.origin.x = emptyWidth / 2 + iconSize + config.spacing
      }
      else {
        iconFrame.origin.x  = emptyWidth / 2 + titleSize.width + config.spacing
        titleFrame.origin.x = emptyWidth / 2
      }
    }

    iconImageView.image = reaction.alternativeIcon ?? reaction.icon
    titleLabel.text     = reaction.title

    iconImageView.frame = iconFrame
    titleLabel.frame    = titleFrame

    UIView.transition(with: titleLabel, duration: 0.15, options: .transitionCrossDissolve, animations: { [unowned self] in
      self.iconImageView.tintColor = self.isSelected ? self.reaction.color : self.config.neutralTintColor
      self.titleLabel.textColor    = self.isSelected ? self.reaction.color : self.config.neutralTintColor
      }, completion: nil)
  }

  // MARK: - Responding to Gesture Events

  func tapAction(_ gestureRecognizer: UITapGestureRecognizer) {
    isSelected = !isSelected

    if isSelected {
      UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeCubic, animations: { [weak self] in
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
          self?.iconImageView.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        })
        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
          self?.iconImageView.transform = .identity
        })
        }, completion: nil)
    }

    sendActions(for: .touchUpInside)
  }

  private var isLongPressMoved = false

  func longPressAction(_ gestureRecognizer: UILongPressGestureRecognizer) {
    guard let reactionSelect = reactionSelectControl else { return }

    if gestureRecognizer.state == .began {
      isLongPressMoved = false

      displayOverlay(feedback: .slideFingerAcross)
    }

    if gestureRecognizer.state == .changed {
      isLongPressMoved = true

      reactionSelect.longPressAction(gestureRecognizer)
    }
    else if gestureRecognizer.state == .ended {
      if isLongPressMoved {
        reactionSelect.longPressAction(gestureRecognizer)

        dismissOverlay()
      }
      else {
        reactionSelect.feedback = .tapToSelectAReaction
      }
    }
  }

  // MARK: - Responding to Select Events

  func reactionTouchedInsideAction(_ sender: ReactionSelectControl) {
    guard let selectedReaction = sender.selectedReaction else { return }

    let isReactionChanged = reaction != selectedReaction

    reaction   = selectedReaction
    isSelected = true

    if isReactionChanged {
      sendActions(for: .valueChanged)
    }
    
    dismissOverlay()
  }

  func reactionTouchedOutsideAction(_ sender: ReactionSelectControl) {
    dismissOverlay()
  }

  // MARK: -

  public func presentOverlay() {
    displayOverlay(feedback: .tapToSelectAReaction)
  }

  public func dismissOverlay() {
    reactionSelectControl?.feedback = nil
    
    animateOverlay(alpha: 0, center: CGPoint(x: overlay.bounds.midX, y: overlay.bounds.midY))
  }

  func displayOverlay(feedback: ReactionFeedback) {
    guard let reactionSelect = reactionSelectControl, let window = UIApplication.shared.keyWindow else { return }

    if overlay.superview == nil {
      UIApplication.shared.keyWindow?.addSubview(overlay)
    }

    overlay.frame = CGRect(x:0 , y: 0, width: window.bounds.width, height: window.bounds.height * 2)

    let centerPoint       = convert(CGPoint(x: bounds.midX, y: 0), to: nil)
    reactionSelect.frame  = reactionSelect.boundsToFit()
    reactionSelect.center = centerPoint

    if reactionSelect.frame.origin.x - config.spacing < 0 {
      reactionSelect.center = CGPoint(x: centerPoint.x - reactionSelect.frame.origin.x + config.spacing, y: centerPoint.y)
    }
    else if reactionSelect.frame.origin.x + reactionSelect.frame.width + config.spacing > overlay.bounds.width {
      reactionSelect.center = CGPoint(x: centerPoint.x - (reactionSelect.frame.origin.x + reactionSelect.frame.width + config.spacing - overlay.bounds.width), y: centerPoint.y)
    }

    reactionSelect.feedback = feedback

    animateOverlay(alpha: 1, center: CGPoint(x: overlay.bounds.midX, y: overlay.bounds.midY - reactionSelect.bounds.height))
  }

  private func animateOverlay(alpha: CGFloat, center: CGPoint) {
    UIView.animate(withDuration: 0.1) { [weak self] in
      guard let overlay = self?.overlay else { return }

      overlay.alpha  = alpha
      overlay.center = center
    }
  }
}
