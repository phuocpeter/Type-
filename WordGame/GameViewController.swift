//
//  GameViewController.swift
//  WordGame
//
//  Created by Phuoc on 2016-12-27.
//  Copyright © 2016 Phuoc. All rights reserved.
//

import UIKit

/// Notifications of the game view controller.
protocol GameViewControllerDelegate {
  func gameFinished()
}

class GameViewController: UITableViewController {
  
  /// Passed from parent view.
  var gameMechanic: GameMechanic!
  /// Keeps track of the time
  var timer: Timer!
  /// Delegate for notification.
  var delegate: GameViewControllerDelegate?
  
  @IBOutlet weak var highScoreLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var wordLabel: UILabel!
  @IBOutlet weak var answerTextField: UITextField!
  
  override func viewDidLoad() {
    // Focus on text field.
    answerTextField.becomeFirstResponder()
    resetView()
    // Fires the timer scheduled for every 1 second.
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
  }
  
  /**
   * Fires every one second.
   * Stops the game when time's up.
   */
  func update() {
    gameMechanic.timeLeft -= 1
    // Changes text colour to red when the time's almost up.
    if gameMechanic.timeLeft <= 5 {
      timeLabel.textColor = UIColor.red
    } else {
      timeLabel.textColor = UIColor.black
    }
    timeLabel.text = String(format: "%0\(3)d", gameMechanic.timeLeft)
    guard gameMechanic.timeLeft <= 0 else {return}
    timer.invalidate()
    displayGameOverAlert()
  }
  
  /**
   * Displays the alert when the game finished.
   * This method also send notification to the parent view.
   */
  func displayGameOverAlert() {
    answerTextField.resignFirstResponder()
    let alert = UIAlertController(title: "Game Over", message: "Your score is \(gameMechanic.score)", preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default) { (alert) in
      self.dismiss(animated: true, completion: nil)
      self.delegate?.gameFinished()
    }
    alert.addAction(ok)
    self.present(alert, animated: true, completion: nil)
  }
  
  /// Called when word is typed correctly.
  func wordCorrect() {
    gameMechanic.score += 1
    resetView()
  }
  
  /**
   * Updates labels and randomizes new word.
   */
  func resetView() {
    highScoreLabel.text = String(format: "%0\(3)d", gameMechanic.highScore)
    scoreLabel.text = String(format: "%0\(3)d", gameMechanic.score)
    timeLabel.text = String(format: "%0\(3)d", gameMechanic.timeLeft)
    gameMechanic.makeNewWord()
    wordLabel.text = gameMechanic.currentWord
    answerTextField.textColor = UIColor.black
    answerTextField.text = ""
  }
  
  @IBAction func quitTapped(sender: UIBarButtonItem) {
    // Dimissed the view
    answerTextField.resignFirstResponder()
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func textChanged(_ sender: UITextField) {
    guard let inputText = sender.text else { return }
    
    // Prevents crash from index overflows.
    guard inputText.characters.count <= gameMechanic.currentWord.characters.count else {
      answerTextField.textColor = UIColor.red
      return
    }
    
    // Substrings the currentWord.
    let index = inputText.endIndex
    let subbedStr = gameMechanic.currentWord.substring(to: index)
    
    // Compares the words.
    if inputText == subbedStr {
      answerTextField.textColor = UIColor.blue
      // Check if the whole word is correct
      guard inputText != gameMechanic.currentWord else {
        wordCorrect()
        return
      }
    } else {
      answerTextField.textColor = UIColor.red
    }
  }
  
}
