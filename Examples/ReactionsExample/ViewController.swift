//
//  ViewController.swift
//  ReactionsExample
//
//  Created by Yannick LORIOT on 01/10/2016.
//  Copyright © 2016 Yannick Loriot. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ReactionFeedbackDelegate {
  @IBOutlet weak var reactionSelect: ReactionSelector!
  @IBOutlet weak var reactionButton: ReactionButton! {
    didSet {
      reactionButton.config = ReactionButtonConfig() {
        $0.alignment = .centerLeft
      }
    }
  }

  // Facebook like

  @IBOutlet weak var facebookReactionButton: ReactionButton! {
    didSet {
      facebookReactionButton.reactionSelector = ReactionSelector()
      facebookReactionButton.config           = ReactionButtonConfig() {
        $0.iconMarging      = 8
        $0.spacing          = 4
        $0.font             = UIFont(name: "HelveticaNeue", size: 14)
        $0.neutralTintColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        $0.alignment        = .left
      }

      facebookReactionButton.reactionSelector?.feedbackDelegate = self
    }
  }
  @IBOutlet weak var reactionSummary: ReactionSummary! {
    didSet {
      reactionSummary.reactions = Reaction.facebook.all
      reactionSummary.text      = "You, Chris Lattner, and 16 others"
      reactionSummary.config    = ReactionSummaryConfig {
        $0.spacing   = 8
        $0.font      = UIFont(name: "HelveticaNeue", size: 12)
        $0.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        $0.alignment = .left
      }
    }
  }
  @IBOutlet weak var feedbackLabel: UILabel! {
    didSet {
      feedbackLabel.isHidden = true
    }
  }

  // MARK: - Action Methods

  @IBAction func reactionChangedAction(_ sender: AnyObject) {
    guard let reaction = reactionSelect.selectedReaction else { return }

    reactionButton.reaction   = reaction
    reactionButton.isSelected = false
  }

  @IBAction func facebookButtonReactionTouchedUpAction(_ sender: AnyObject) {
    if facebookReactionButton.isSelected == false {
      facebookReactionButton.reaction   = Reaction.facebook.like
    }
  }

  @IBAction func summaryTouchedAction(_ sender: AnyObject) {
    facebookReactionButton.presentReactionSelector()
  }

  // MARK: - ReactionFeedback Methods

  func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
    feedbackLabel.isHidden = feedback == nil

    feedbackLabel.text = feedback?.localizedString
  }
}

