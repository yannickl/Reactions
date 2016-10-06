//
//  ViewController.swift
//  ReactionsExample
//
//  Created by Yannick LORIOT on 01/10/2016.
//  Copyright © 2016 Yannick Loriot. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ReactionFeedbackDelegate {
  @IBOutlet weak var reactionSelect: ReactionSelect!
  @IBOutlet weak var reactionButton: ReactionButton! {
    didSet {
      reactionButton.alignment = .centerLeft
    }
  }
  @IBOutlet weak var dynamicReactionButton: ReactionButton! {
    didSet {
      dynamicReactionButton.alignment            = .right
      dynamicReactionButton.reaction             = Reaction.facebook.love
      dynamicReactionButton.linkedReactionSelect = ReactionSelect()

      dynamicReactionButton.linkedReactionSelect?.feedbackDelegate = self
    }
  }
  @IBOutlet weak var reactionSummary: ReactionSummary! {
    didSet {
      reactionSummary.reactions = Reaction.facebook.all
      reactionSummary.alignment = .left
      reactionSummary.text      = "Description"
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Action Methods

  @IBAction func reactionChangedAction(_ sender: AnyObject) {
    guard let reaction = reactionSelect.selectedReaction else { return }

    reactionButton.reaction   = reaction
    reactionButton.isSelected = false
  }
  
  @IBAction func summaryTouchedAction(_ sender: AnyObject) {
    dynamicReactionButton.presentOverlay()
  }

  // MARK: - ReactionFeedback Methods

  func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
    print("reactionFeedbackDidChanged \(feedback)")
  }
}

