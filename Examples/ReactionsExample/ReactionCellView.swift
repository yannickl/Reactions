//
//  ReactionCellView.swift
//  ReactionsExample
//
//  Created by Yannick LORIOT on 20/08/2018.
//  Copyright © 2018 Yannick Loriot. All rights reserved.
//

import Foundation
import UIKit

final class ReactionCellView: UITableViewCell {
  @IBOutlet var avatarImageView: UIImageView! {
    didSet {
      avatarImageView.layer.masksToBounds = true
      avatarImageView.layer.cornerRadius  = 18
    }
  }

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
      facebookReactionButton.willShowSelector = {
            print("HAHAHAA")
        }
        
      facebookReactionButton.didHideSelector = {
            print("HIDE ROOIF KIA")
        }
    }
  }
  @IBOutlet weak var reactionSummary: ReactionSummary! {
    didSet {
      reactionSummary.reactions = Reaction.facebook.all
      reactionSummary.setDefaultText(withTotalNumberOfPeople: 4, includingYou: true)
      reactionSummary.config    = ReactionSummaryConfig {
        $0.spacing      = 8
        $0.iconMarging  = 2
        $0.font         = UIFont(name: "HelveticaNeue", size: 12)
        $0.textColor    = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        $0.alignment    = .left
        $0.isAggregated = true
      }
    }
  }
  @IBOutlet weak var feedbackLabel: UILabel! {
    didSet {
      feedbackLabel.isHidden = true
    }
  }

  // Actions

  @IBAction func facebookButtonReactionTouchedUpAction(_ sender: AnyObject) {
    if facebookReactionButton.isSelected == false {
      facebookReactionButton.reaction   = Reaction.facebook.like
    }
  }

  @IBAction func summaryTouchedAction(_ sender: AnyObject) {
    facebookReactionButton.presentReactionSelector()
  }
}

extension ReactionCellView: ReactionFeedbackDelegate {
  func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
    feedbackLabel.isHidden = feedback == nil

    feedbackLabel.text = feedback?.localizedString
  }
}
