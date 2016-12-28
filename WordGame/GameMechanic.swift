//
//  GameMechanic.swift
//  WordGame
//
//  Created by Phuoc on 2016-12-27.
//  Copyright © 2016 Phuoc. All rights reserved.
//

import Foundation

/**
 * Game Mechanic hold all the neccessities of the game's function.
 */
class GameMechanic {
  
  /// 1 point is added for each word typed.
  var score = 0 {
    didSet {
      // Adds time bonus.
      if score % 5 == 0 { timeLeft += 20 }
      highScore = max(score, highScore)
    }
  }
  /// High score.
  var highScore = 0
  /// Time left before the game ends.
  var timeLeft = 0
  /// Current word that the player have to type.
  var currentWord = ""
  
  init() {
    reset()
  }
  
  /**
   * Resets the game.
   */
  func reset() {
    score = 0
    timeLeft = 40
  }
  
  /**
   * Randomizes a nonsensical word and stores it in currentWord.
   */
  func makeNewWord() {
    var word = [Character]()
    // Randomizes word length.
    let wordLength = Int(arc4random_uniform(7)) + 5
    for _ in 0...wordLength {
      // Randomizes the chances of word being lowercased.
      var x = 65
      if (Int(arc4random_uniform(2)) == 1) {
        x = 97
      }
      // Randomizes the character.
      if let unicode = UnicodeScalar(Int(arc4random_uniform(24)) + x) {
        word.append(Character(unicode))
      }
    }
    currentWord = String(word)
  }
  
}
