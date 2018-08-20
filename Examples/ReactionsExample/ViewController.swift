//
//  ViewController.swift
//  ReactionsExample
//
//  Created by Yannick LORIOT on 01/10/2016.
//  Copyright © 2016 Yannick Loriot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var reactionSelect: ReactionSelector!
  @IBOutlet weak var reactionButton: ReactionButton! {
    didSet {
      reactionButton.config = ReactionButtonConfig() {
        $0.alignment = .centerLeft
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Reactions"
  }

  // MARK: - Action Methods

  @IBAction func reactionChangedAction(_ sender: AnyObject) {
    guard let reaction = reactionSelect.selectedReaction else { return }

    reactionButton.reaction   = reaction
    reactionButton.isSelected = false
  }
}

