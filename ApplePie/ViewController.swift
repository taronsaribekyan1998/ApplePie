//
//  ViewController.swift
//  ApplePie
//
//  Created by Taron on 13.05.22.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Outlets
    
    @IBOutlet var treeImageView: UIImageView!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var correctWordLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    
    // MARK: Properties
    
    var listOfWords  = ["swift", "bug", "hello", "developer", "programming", "apple", "computer", "smartphone", "application", "software", "screen", "code", "compiler", "error", "system", "designer", "employee", "remote", "job", "beginner", "update", "store", "electronics"]
    let incorrectMovesAllowed = 7
    var currentGame: Game!
    
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    
    var totalLosses = 0 {
        didSet {
            if totalLosses == 3 {
                gameOverUpdateUI()
            } else {
                newRound()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLetterButtons(false)
        treeImageView.image = UIImage(named: "Tree7")
    }
    
    // MARK: Actions
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        correctWordLabel.textColor = .black
        sender.isHidden = true
        if totalLosses == 3 {
            //didSet is being called with newRound()
            totalLosses = 0
            totalWins = 0
        } else {
            // if fisrt time playing
            newRound()
        }
    }
    
    @IBAction func letterButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    // MARK: Functions
    
    func newRound() {
        let newWord = listOfWords.randomElement()!
        currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
        enableLetterButtons(true)
        updateUI()
    }
    
    func updateUI() {
        correctWordLabel.text = currentGame.formattedWord
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree\(currentGame.incorrectMovesRemaining)")
    }
    
    func gameOverUpdateUI() {
        treeImageView.image = UIImage(named: "Tree0")
        enableLetterButtons(false)
        correctWordLabel.text = "Game Over"
        correctWordLabel.textColor = .systemRed
        scoreLabel.text = "Wins: \(totalWins), Losses: 3"
        startButton.isHidden = false
    }
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            totalLosses += 1
        } else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
            updateUI()
        } else {
            updateUI()
        }
    }
    
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
}
