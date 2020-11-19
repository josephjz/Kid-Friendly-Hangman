//  ViewController.swift
//  Kid-Friendly Hangman
//
//  Created by Jennifer Joseph
//  Word Garden App for Professor Gallaugher's Swift/iOS App Development Class Fall 2020
//  Built this app using Prof G's Textbook Chapter 3
//
//  Rebuilding app for practice for iOS Midterm Novemmber 23

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = guessedLetterField.text!  // NOTE: THIS IS AN OPTIONAL
        guessLetterButton.isEnabled = !(text.isEmpty)
    }
    
    func updateUIAfterGuesses() {
        // dismisses keyboard
        // when the Text Field is tapped, it becomes the First Responder
        guessedLetterField.resignFirstResponder()
        
        // reset the text field to an empty string
        guessedLetterField.text! = ""
        guessLetterButton.isEnabled = false
    }
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        // disables guess a letter button if there is no letter input
        // action connected to Text Field that user inputs guessed letter into
        // Type of the connection is UITextField, Event is Editing Changed
        // EDITING CHANGED FIRES WHEN ANY CHANGES ARE MADE WITHIN TEXT FIELD
        let text = guessedLetterField.text!  // NOTE: THIS IS AN OPTIONAL
        guessLetterButton.isEnabled = !(text.isEmpty)
        
        // could have done this with if, else but this is much cleaner
        // guessedLetterButton.isEnabled and text.isEmpty are both boolean
        // so by setting them equal to the opposite of eachother means the button will be enabled when the text is not empty / disable when text is empty
        // better way to toggle F to T and T to F
    }
    
    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
        // action connected to Text Field that user inputs guessed letter into
        // Type of the connection is UIButton, Event is Touch Up Inside
        // TOUCH UP INSIDE FIRES WHEN BUTTON IS HIT
        updateUIAfterGuesses()  // executes actions after guess a letter button is pressed
    }
    
    @IBAction func doneButtonPressed(_ sender: UITextField) {
        // action connected to Text Field that user inputs guessed letter into
        // Type of the connection is UITextField, Event is Primary Action Triggered
        // PRIMARY ACTION TRIGGERED FIRES WHEN RETURN/DONE KEY IS PRESSED
        updateUIAfterGuesses()  // executes actions after done bytton is pressed
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
    }
    
}

