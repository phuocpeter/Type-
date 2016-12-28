//
//  ViewController.swift
//  WordGame
//
//  Created by Phuoc on 2016-12-27.
//  Copyright © 2016 Phuoc. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController, GameViewControllerDelegate {

  let defaults = UserDefaults.standard
  let gameMechanic = GameMechanic()
  
  @IBOutlet weak var highScoreLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Loads and displays highscore
    let highScore = defaults.integer(forKey: "highScore")
    highScoreLabel.text = String(format: "%0\(3)d", highScore)
    gameMechanic.highScore = highScore
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let id = segue.identifier else { return }
    switch id {
    case "startGame":
      let navigationController = segue.destination as! UINavigationController
      let gameViewController = navigationController.topViewController as! GameViewController
      // Setups for the game view controller
      gameMechanic.reset()
      gameViewController.delegate = self
      gameViewController.gameMechanic = self.gameMechanic
      break
    default:
      break
    }
  }
  
  /**
   * Updates high score.
   */
  func gameFinished() {
    let highScore = max(gameMechanic.highScore, gameMechanic.score)
    defaults.set(highScore, forKey: "highScore")
    highScoreLabel.text = String(format: "%0\(3)d", highScore)
    gameMechanic.highScore = highScore
  }
  
}
