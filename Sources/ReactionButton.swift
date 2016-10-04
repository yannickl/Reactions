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
public final class ReactionButton: ReactionControl {
  private let iconImageView: UIImageView = ComponentBuilder.ReactionButton.facebookLikeIcon
  private let titleLabel: UILabel        = ComponentBuilder.ReactionButton.facebookLikeLabel

  private let spacing: CGFloat     = 8
  private let iconMarging: CGFloat = 8

  public var textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
  public var reaction  = Reaction.facebook.first! {
    didSet {
      iconImageView.image = reaction.alternativeIcon ?? reaction.icon
      titleLabel.text     = reaction.title
    }
  }

  private lazy var tapGesture: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(ReactionButton.tapAction))

    return gesture
  }()

  // MARK: - Building Object

  override func setup() {
    addGestureRecognizer(tapGesture)

    addSubview(iconImageView)
    addSubview(titleLabel)
  }

  // MARK: - Updating Object State
  
  override func update() {
    let iconSize = min(bounds.width, bounds.height) - iconMarging

    iconImageView.frame = CGRect(x: 0, y: (bounds.height - iconSize) / 2, width: iconSize, height: iconSize)
    titleLabel.frame    = CGRect(x: iconSize + spacing, y: 0, width: bounds.width - iconSize - spacing, height: bounds.height)
  }

  // MARK: - Responding to Tap Gesture

  func tapAction(_ gestureRecognizer: UITapGestureRecognizer) {
    UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .calculationModeCubic, animations: { [weak self] in
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
        self?.iconImageView.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        self?.iconImageView.tintColor = self?.reaction.color
        self?.titleLabel.textColor    = self?.reaction.color
      })
      UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: { 
        self?.iconImageView.transform = .identity
      })
      }, completion: nil)
  }
}
