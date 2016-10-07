//
//  ViewController.swift
//  ReactionsExample
//
//  Created by Yannick LORIOT on 01/10/2016.
//  Copyright © 2016 Yannick Loriot. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ReactionFeedbackDelegate {
  @IBOutlet weak var reactionSelect: ReactionSelectControl!
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
      facebookReactionButton.reactionSelectControl = ReactionSelectControl()
      facebookReactionButton.config                = ReactionButtonConfig() {
        $0.iconMarging = 8
        $0.spacing     = 4
        $0.font        = UIFont(name: "HelveticaNeue", size: 14)
      }

      facebookReactionButton.reactionSelectControl?.feedbackDelegate = self
    }
  }
  @IBOutlet weak var reactionSummary: ReactionSummary! {
    didSet {
      reactionSummary.reactions = Reaction.facebook.all
      reactionSummary.alignment = .left
      reactionSummary.text      = "A description"
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
    facebookReactionButton.presentOverlay()
  }

  // MARK: - ReactionFeedback Methods

  func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
    feedbackLabel.isHidden = feedback == nil

    feedbackLabel.text = feedback?.localizedString()
  }
}

