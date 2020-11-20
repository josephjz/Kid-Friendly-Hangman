//  ViewController.swift
//  Kid-Friendly Hangman
//
//  Created by Jennifer Joseph
//  Word Garden App for Professor Gallaugher's Swift/iOS App Development Class Fall 2020
//  Built this app using Prof G's Textbook Chapter 3
//
//  Rebuilding app for practice for iOS Midterm Novemmber 23

import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var wordsInGameLabel: UILabel!
    @IBOutlet weak var wordsGuessedLabel: UILabel!
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    @IBOutlet weak var wordsMissedLabel: UILabel!
    @IBOutlet weak var wordBeingRevealedLabel: UILabel!
    @IBOutlet weak var guessedLetterField: UITextField!
    @IBOutlet weak var guessLetterButton: UIButton!
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var flowerImageView: UIImageView!
    
    var wordsToGuess = ["FLY", "DOG", "CAT"]
    var currentWordIndex = 0
    var wordToGuess = ""
    var lettersGuessed = ""
    
    let maxWrongGuesses = 8
    var wrongGuessesRemaining = 8
    
    var wordsGuessedCount = 0
    var wordsMissedCount = 0
    var guessCount = 0
    
    var audioPlayer : AVAudioPlayer! // remember you have to force unwrap this optional to declare it without giving it a value

    override func viewDidLoad() {
        super.viewDidLoad()
        let text = guessedLetterField.text!  // NOTE: THIS IS AN OPTIONAL
        guessLetterButton.isEnabled = !(text.isEmpty)
        wordToGuess = wordsToGuess[currentWordIndex]
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count - 1)
        gameStatusLabel.text = "You have made 0 guesses"
        updateGameStatusLabels()
    }
    
    func updateUIAfterGuesses() {
        // dismisses keyboard
        // when the Text Field is tapped, it becomes the First Responder
        guessedLetterField.resignFirstResponder()
        
        // reset the text field to an empty string
        guessedLetterField.text! = ""
        guessLetterButton.isEnabled = false
    }
    
    func formatRevealedWord() {
        var revealedWord = ""
        
        for letter in wordToGuess {
            if lettersGuessed.contains(letter) {
                revealedWord += "\(letter) "
            } else {
                revealedWord += "_ "
            }
        }
        revealedWord.removeLast()
        wordBeingRevealedLabel.text = revealedWord
    }
    
    func guessALetter() {
        // get currently guessed letter and add it to all letters guessed
        let currentLetterGuessed = guessedLetterField.text ?? ""
        lettersGuessed += currentLetterGuessed
        formatRevealedWord()
        
        drawFlowerAndPlaySound(currentLetterGuessed: currentLetterGuessed)
        
        // update gameStatusLabel
        guessCount += 1
        let plural = (guessCount == 1 ?  "guess" :  "guesses")
        gameStatusLabel.text = "You have made \(guessCount) \(plural)"
        
        // after each guess, check if the user won the game (all letters have been guessed, so no more _ in beingChecked
        //                         if they lost, they are out of guesses remaining
        if wordBeingRevealedLabel.text?.contains("_") == false {
            playSound(soundName: "word-guessed")
            gameStatusLabel.text = "YOU WON in \(guessCount) \(plural)"
            wordsGuessedCount += 1
            updateAfterWinOrLose()
        } else if wrongGuessesRemaining == 0 {
            gameStatusLabel.text = "YOU LOST in \(guessCount) \(plural)"
            wordsMissedCount += 1
            updateAfterWinOrLose()
        }
        // check to see if played the whole game
        if currentWordIndex == wordsToGuess.count {
            gameStatusLabel.text! += "You have tried all of the words. Restart from the beginning?"
        }
    }
    
    
    func updateAfterWinOrLose() {
        // if game is over
        currentWordIndex += 1
        guessedLetterField.isEnabled = false
        guessLetterButton.isEnabled = false
        playAgainButton.isHidden = false
        updateGameStatusLabels()
    }
    
    func updateGameStatusLabels(){
        wordsGuessedLabel.text = "Words Guessed: \(wordsGuessedCount)"
        wordsMissedLabel.text = "Words Missed: \(wordsMissedCount)"
        wordsRemainingLabel.text = "Words Remaining: \(wordsToGuess.count - (wordsGuessedCount + wordsMissedCount))"
        wordsInGameLabel.text = "Words in Game: \(wordsToGuess.count)"
    }
    
    
    // playSound() is a helper function
    func playSound(soundName: String) {
        if let sound = NSDataAsset(name: soundName) {
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch { print("Error: \(error.localizedDescription) could not initialize plauyer")}
        } else {
            print("Error: could not read file")
        }
    }
    
    
    func drawFlowerAndPlaySound(currentLetterGuessed: String) {
        //update image if needed, and keep track of wrong guesses
        if !wordToGuess.contains(currentLetterGuessed) {
            wrongGuessesRemaining -= 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                UIView.transition(with: self.flowerImageView, duration: 0.5, options: .transitionCrossDissolve) {
                    self.flowerImageView.image = UIImage(named: "wilt\(self.wrongGuessesRemaining)")
                } completion: { (_) in
                    if self.wrongGuessesRemaining != 0 {
                        self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")
                    } else {
                        self.playSound(soundName: "word-not-guessed")
                        UIView.transition(with: self.flowerImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")
                        }, completion: nil)
                    }
                }
                self.playSound(soundName: "incorrect")
            }
        } else {
            playSound(soundName: "correct")
        }
    }
 
    
    
    
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        // disables guess a letter button if there is no letter input
        // action connected to Text Field that user inputs guessed letter into
        // Type of the connection is UITextField, Event is Editing Changed
        // EDITING CHANGED FIRES WHEN ANY CHANGES ARE MADE WITHIN TEXT FIELD
        
        // could have done this with if, else but this is much cleaner
        // guessedLetterButton.isEnabled and text.isEmpty are both boolean
        // so by setting them equal to the opposite of eachother means the button will be enabled when the text is not empty / disable when text is empty
        // better way to toggle F to T and T to F
        let text = guessedLetterField.text!  // NOTE: THIS IS AN OPTIONAL
        guessLetterButton.isEnabled = !(text.isEmpty)
        
        // NOW, rewriting function code so that it now tries to get the last letter the user has entered (previously could enter multiple letters but that doesn't make sense for this game)
        // if the last letter is a valid character, put this into guessed letter text field
        // else (case that the last letter is not valid aka nil) put an empty string into the text field
        // end result: single character in textField (last letter typed) or if no characters (because user deleted them) put empty string
        
        guessedLetterField.text = String(guessedLetterField.text?.last ?? " ").trimmingCharacters(in: .whitespaces).uppercased()
        
       
    }
    
    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
        guessALetter()
        // action connected to Text Field that user inputs guessed letter into
        // Type of the connection is UIButton, Event is Touch Up Inside
        // TOUCH UP INSIDE FIRES WHEN BUTTON IS HIT
        updateUIAfterGuesses()  // executes actions after guess a letter button is pressed
    }
    
    @IBAction func doneButtonPressed(_ sender: UITextField) {
        guessALetter()
        // action connected to Text Field that user inputs guessed letter into
        // Type of the connection is UITextField, Event is Primary Action Triggered
        // PRIMARY ACTION TRIGGERED FIRES WHEN RETURN/DONE KEY IS PRESSED
        updateUIAfterGuesses()  // executes actions after done bytton is pressed
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        
        // if all words have been guessed, restart
        if currentWordIndex == wordsToGuess.count {
            currentWordIndex = 0
            wordsMissedCount = 0
            wordsGuessedCount = 0
        }
        
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordsToGuess[currentWordIndex].count - 1)
        playAgainButton.isHidden = true
        guessedLetterField.isEnabled = true
        guessLetterButton.isEnabled = false
        wordToGuess = wordsToGuess[currentWordIndex]
        wrongGuessesRemaining = maxWrongGuesses
        gameStatusLabel.text = "You have made 0 guesses"
        guessCount = 0
        lettersGuessed = ""
        flowerImageView.image = UIImage(named: "flower\(maxWrongGuesses)")
        updateGameStatusLabels()
    }
    
}

