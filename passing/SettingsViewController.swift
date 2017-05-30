//
//  SettingsViewController.swift
//  passing
//
//  Created by Grant Schulte on 5/24/17.
//  Copyright © 2017 Xiwei M. All rights reserved.
//


// ###########################################################
// #################### READ THIS PLEASE #####################
// ###########################################################
// ##                                                       ##
// ## Once the user finishes setting up a password and      ##
// ## clicks "Save" or whatever, run these lines of code:   ##
// ##                                                       ##
// ## UserDefaults.standard.set(false, forKey: "firstTime") ##
// ## self.firstTime = false                                ##
// ##                                                       ##
// ## This will keep track of the fact that the user has    ##
// ## already set up a password so that he/she will be      ##
// ## directed to the correct launch screen next time       ##
// ## he/she opens the app!                                 ##
// ##                                                       ##
// ## Thanks!                                               ##
// ## -Grant                                                ##
// ##                                                       ##
// ###########################################################
// #################### READ THIS PLEASE #####################
// ###########################################################


// ###########################################################
// #################### READ THIS PLEASE #####################
// ###########################################################
//
// Also I have copied and pasted my audiokit functions to this
// file so that it is easier to use. The useful functions are:
//
// ----- TURNING ON / OFF AUDIOKIT MICROPHONE INPUT: -----
//
// (1) initializeAudioKitForMicInput(timeIntervalBetweenNoteSamples)
//      - ## CALL WHEN THE USER PRESSES A BUTTON TO BEGIN RECORDING HIS/HER PASSWORD ##
//      - Turn on microphone input and initialize AudioKit to start detecting notes
//      - Adds recognized notes to the String array "recordedNotes". Also updates UILabel "detectedNotesLabel".
//      - Call exactly like this, passing in variable "timeIntervalBetweenNoteSamples" --> pre-set to 0.05, which I found to be optimal
// (2) stopAudioKitMicInput()
//      - ## CALL AFTER THE USER FINISHES RECORDING HIS/HER PASSWORD AND CLICKS THE BUTTON TO STOP RECORDING ##
//      - Turn off microphone input, stop detecting notes, and suspend AudioKit
//
// ----- PLAYING INDIVIDUAL NOTES THROUGH THE SPEAKERS -----
//
// (3) playNote(Note note: String, RaiseOctaveBy octaveMultiplier: Double)
//      - Plays a single note, passed in as a string
//      - Temporarily suspends microphone input using stopAudioKitMicInput() [automatic]
//      - @param "note": The note to be played, in the format "G#2", where "G# is the note and "2" is the octave
//      - @param "octaveMultiplier" should be 2 so that the note is more audible/recognizable
// (4) stopPlayingNote()
//      - Stops playing the note and suspends AudioKit
//      - Automatically turns back on note input through the microphone. (Turn back off by calling: stopAudioKitMicInput() )
//
// ----- FULL PASSWORD PLAYBACK THROUGH THE SPEAKERS -----
//
// (5) playPassword(noteDuration: Double)
//      - Plays the notes of the password (stored in the String array "password")
//      - @param noteDuration: How long each note in the sequence should play for. Usually 0.5 seconds is good.
//
//
// ###########################################################
// #################### READ THIS PLEASE #####################
// ###########################################################
//
// In addition, the useful variables already set up, which you will want to use for this View Controller, are:
// (A) recordedNotes: [String array]
//      - Array that stores all of the notes that the user has sung into the microphone
//      - *** After the user finishes singing their password,
//          set "password = recordedNotes" to save the notes into the password array. This also is
//          necessary for the user to playback the password, since "playPassword(0.5)" works by reading the "password" array
//      - If the user doesn't like it decides to start over and re-record, empty this array with "recordedNotes = []" and the password array with "password = []"
// (B) password: [String array]
//      - Array that stores the notes in the user's password as String objects
//      - NOTES ARE PLAYED FROM THIS ARRAY when "playPassword(0.5)" is called, so keep it updated by setting "password = recordedNotes" whenever the user finishes recording a take during password set-up.





import UIKit
import AudioKit


class SettingsViewController: UIViewController {
    
    var firstTime: Bool = false
    
    @IBOutlet weak var textPasswordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        AKSettings.audioInputEnabled = false
        stopAudioKitMicInput()
    }
    
    
    
    
    
    
    
    
    
    // ----------------------------------- Begin AudioKit Stuff ----------------------------------- //
    
    @IBOutlet weak var detectedNotesLabel: UILabel!
    
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNames = ["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"]  // Generic names of notes, uses combo of #'s and b's
    let noteNamesWithSharps = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]  // Notes with only #'s
    let noteNamesWithFlats = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]  // Notes with only b's
    
    // Arrays for keeping track of notes sung + notes in the password itself
    var password: [String] = []  // USE THIS TO STORE THE PASSWORD
    var recordedNotes: [String] = []  // Contains the notes that the player has sung since the mic has been on
    var lastThreeNotesDetected: [String] = ["empty1", "empty2", "empty3"]  // Used "under the hood". Keep track of last 3 notes recorded to account for voice modulations. Note: Initializations MUST be different values
    
    let timeIntervalBetweenNoteSamples: Double = 0.05
    
    var playingNote: Bool = false
    let notePlayer: AKOscillator = AKOscillator()
    
    
    
    // Used "under the hood" -- DON'T CALL ON ITS OWN
    func updateUI() {
        if (tracker.amplitude > 0.1) {
            
            var frequency = Float(tracker.frequency)
            while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
                frequency /= 2.0
            }
            while frequency < Float(noteFrequencies[0]) {
                frequency *= 2.0
            }
            
            var minDistance: Float = 10_000.0
            var index = 0
            
            for i in 0..<noteFrequencies.count {
                let distance = fabsf(Float(noteFrequencies[i]) - frequency)
                if distance < minDistance {
                    index = i
                    minDistance = distance
                }
            }
            let octave = Int(log2f(Float(tracker.frequency) / frequency))
            
            // Put the note data into the form of a String
            let currentNote: String = "\(noteNames[index])\(octave)"
            
            // Procedurally stream notes into the lastThreeNotesDetected array
            for i in 0..<(lastThreeNotesDetected.count - 1) {
                lastThreeNotesDetected[i] = lastThreeNotesDetected[i+1]
            }
            lastThreeNotesDetected[lastThreeNotesDetected.count - 1] = currentNote
            
            // The note must have shown up 3x in the last 3 samples for it to be confirmed as a correct note and added to recordedNotes (to prevent false readings due to voice fluctuations)
            var noteCount: Int = 0
            for i in lastThreeNotesDetected {
                if (currentNote == i) {
                    noteCount += 1
                }
            }
            
            if (noteCount == 3) {
                // Store the current Note ONLY if it isn't the same as the previous one
                if (recordedNotes.count != 0) {
                    
                    // Test if the note being sung was already added to recordedNotes
                    if (recordedNotes[recordedNotes.count - 1] != currentNote) {
                        
                        // Add the note name to the array of Recorded Notes
                        recordedNotes.append(currentNote)
                        
                        // Update label for list of all notes sung
                        detectedNotesLabel.text?.append(", \(currentNote)")
                    }
                } else {
                    recordedNotes.append(currentNote)
                    
                    // Update label for list of all notes sung
                    detectedNotesLabel.text?.append(", \(currentNote)")
                }
                
            }
        }
        
    }
    
    
    var timer_audioInputInterval: Timer = Timer()
    
    func initializeAudioKitForMicInput(timeBetweenNotes timeInterval: Double) {
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        AudioKit.output = silence
        AudioKit.start()
        timer_audioInputInterval = Timer.scheduledTimer(timeInterval: timeIntervalBetweenNoteSamples,
                                                        target: self,
                                                        selector: #selector(ViewController.updateUI),
                                                        userInfo: nil,
                                                        repeats: true)
    }
    
    func stopAudioKitMicInput() {
        timer_audioInputInterval.invalidate()
        AudioKit.stop()
    }
    
    
    // Note should be written in the form "G#2", where "G#" is the note and "2" is the octave
    func getNotePlaybackFrequency(NoteString note: String)-> Double {
        let noteValue: String = note.substring(to: note.index(note.endIndex, offsetBy: -1))
        if let octave: Int = Int( note.substring(from: note.index(note.endIndex, offsetBy: -1)) ) {
            print("Note: \(noteValue); Octave: \(octave)")
            for i in 0 ..< noteNames.count {
                if (noteValue == noteNamesWithFlats[i]) {
                    var frequency = noteFrequencies[i]  // Base frequency for Octave 1. Same index as note name/value
                    for _ in 0 ..< octave {  // Each octave doubles the frequency (frequency = base_frequency * 2^octave), where base_octave=0
                        frequency *= 2
                    }
                    return frequency
                }
                if (noteValue == noteNamesWithSharps[i]) {
                    var frequency = noteFrequencies[i]  // Base frequency for Octave 1. Same index as note name/value
                    for _ in 0 ..< octave {  // Each octave doubles the frequency (frequency = base_frequency * 2^octave), where base_octave=0
                        frequency *= 2
                    }
                    return frequency
                }
            }
        }
        print("Could not determine note frequency from the argument \"note\". Check that the note passed into getNotePlaybackFrequency(...) is in the form: NoteValue + Octave (i.e. \"C#2\") and that the note value actually exists (i.e. \"B#\" or \"Hb\" are not valid notes)")
        return 0.0
    }
    
    
    func playNote(Note note: String, RaiseOctaveBy octaveMultiplier: Double) {
        stopAudioKitMicInput()  // Note: can stop AK as many times as needed, but can't start AK multiple times in a row without stopping
        notePlayer.amplitude = 0.2
        notePlayer.frequency = getNotePlaybackFrequency(NoteString: note) * pow(2, octaveMultiplier)  // Raise by some number of octaves to make more audible
        AudioKit.output = notePlayer
        AudioKit.start()
        notePlayer.start()
        playingNote = true
    }
    
    func stopPlayingNote() {
        AudioKit.stop()  // Note: can stop AK as many times as needed, but can't start AK multiple times in a row without stopping
        notePlayer.stop()
        initializeAudioKitForMicInput(timeBetweenNotes: timeIntervalBetweenNoteSamples)  // Restart AudioKit to enable audio input
        playingNote = false
    }
    
    
    var pw_playingNoteIndex: Int = 0
    var timer_playPassword: Timer = Timer()
    
    func playPassword(noteDuration: Double) {
        timer_playPassword = Timer.scheduledTimer(timeInterval: noteDuration,
                                                  target: self,
                                                  selector: #selector(playCurrentNoteInPassword),
                                                  userInfo: nil,
                                                  repeats: true)
    }
    
    func playCurrentNoteInPassword() {
        playNote(Note: password[pw_playingNoteIndex], RaiseOctaveBy: 2)
        pw_playingNoteIndex += 1
        if (pw_playingNoteIndex >= password.count) {
            timer_playPassword.invalidate()
            pw_playingNoteIndex = 0  // Reset index for next time password is played
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(stopPlayingNote), userInfo: nil, repeats: false)  // Turn off last note after 0.5 seconds
        }
    }
    
    
    var textPassword = ""
    
    
    @IBAction func getTextPasswordInput(_ sender: UITextField) {
        textPassword = self.textPasswordInput.text!
    }
    
    @IBAction func recordSongPassword(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Song Password Creation", message: "Press 'Okay' and sing your password using the microphone. Press the 'Stop Recording' button when you have finished.", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertController, animated: true, completion: nil)
        let OKAction = UIAlertAction(title: "OK", style:.default) { (action:UIAlertAction) in
            self.initializeAudioKitForMicInput(timeBetweenNotes: 0.05)
            print("Did perform initialization!")}
        alertController.addAction(OKAction)
    }
    @IBAction func stopRecordingPassword(_ sender: UIButton) {
        self.stopAudioKitMicInput()
    }
    
    
    @IBAction func playbackSongPassword(_ sender: UIButton) {
        playPassword(noteDuration: 0.5)
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "firstTime")
        self.firstTime = false
    }
}


