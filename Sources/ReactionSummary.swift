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
  private let textLabel    = UILabel()
  private var summaryLayer = CAReactionSummaryLayer()

  /**
   The reaction summary configuration.
   */
  public var config: ReactionSummaryConfig = ReactionSummaryConfig() {
    didSet { update() }
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

  // MARK: - Localizing Default Summary Text

  /**
   Convenient method to set a default localized text in order to display the given total number of people including you.
   
   For example:
   ```
   let summary = ReactionSummary()
   
   summary.setDefaultText(withTotalNumberOfPeople: 3, includingYou: false)
   
   print(summary.text) // 3
   
   summary.setDefaultText(withTotalNumberOfPeople: 3, includingYou: true)
   
   print(summary.text) // You and 2 others
   ```

   - Parameter peopleNumber: The total number of people.
   - Parameter includingYou: A flag to know whether you are included in the total number of people.
   */
  public func setDefaultText(withTotalNumberOfPeople peopleNumber: Int, includingYou: Bool = false) {
    let localizedFormat: String
    let total: Int

    if includingYou && peopleNumber > 0 {
      localizedFormat = "summary.you".localized(from: "ReactionSummaryLocalizable")
      total           = Int(peopleNumber - 1)
    }
    else {
      localizedFormat = "summary.other".localized(from: "ReactionSummaryLocalizable")
      total           = Int(peopleNumber)
    }

    text = String.localizedStringWithFormat(localizedFormat, total)
  }

  // MARK: - Building Object

  override func setup() {
    gestureRecognizers?.forEach {
      removeGestureRecognizer($0)
    }

    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReactionSummary.tapAction)))

    textLabel.removeFromSuperview()
    summaryLayer.removeFromSuperlayer()

    summaryLayer.reactions = reactions

    layer.addSublayer(summaryLayer)
    addSubview(textLabel)
  }

  // MARK: - Updating Object State

  override func update() {
    updateComponentConfig()
    updateComponentFrame()
  }

  private func updateComponentConfig() {
    textLabel.font      = config.font
    textLabel.textColor = config.textColor
    summaryLayer.frame  = bounds
    summaryLayer.config = config

    switch config.alignment {
    case .left, .centerLeft:
      textLabel.lineBreakMode = .byTruncatingTail
    case .right, .centerRight:
      textLabel.lineBreakMode = .byTruncatingHead
    }
  }

  private func updateComponentFrame() {
    let textLabelSize    = textLabel.sizeThatFits(bounds.size)
    let summaryLayerSize = summaryLayer.sizeToFit()

    let textLabelX: CGFloat
    let summaryLayerX: CGFloat

    let textLabelWidth = min(textLabelSize.width, bounds.width - summaryLayerSize.width - config.spacing)
    let margin         = (bounds.width - (summaryLayerSize.width + config.spacing + textLabelWidth)) / 2

    switch config.alignment {
    case .left:
      summaryLayerX = 0
      textLabelX    = summaryLayerSize.width + config.spacing
    case .right:
      summaryLayerX = bounds.width - summaryLayerSize.width
      textLabelX    = bounds.width - summaryLayerSize.width - config.spacing - textLabelWidth
    case .centerLeft:
      summaryLayerX = margin
      textLabelX    = margin + textLabelWidth + config.spacing
    case .centerRight:
      summaryLayerX = margin + textLabelWidth + config.spacing
      textLabelX    = margin
    }

    textLabel.frame    = CGRect(x: textLabelX, y: 0, width: textLabelWidth, height: bounds.height)
    summaryLayer.frame = CGRect(x: summaryLayerX, y: 0, width: summaryLayerSize.width, height: bounds.height)
  }

  // MARK: - Responding to Gesture Events

  func tapAction(_ gestureRecognizer: UITapGestureRecognizer) {
    sendActions(for: .touchUpInside)
  }
}
