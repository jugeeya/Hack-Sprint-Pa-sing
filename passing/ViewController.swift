
import UIKit
import AudioKit


class ViewController: UIViewController {

    var firstTime: Bool = true;
    
    
    @IBOutlet weak var Processed: UILabel!
    @IBOutlet weak var passwordStatusLabel: UILabel!
    @IBOutlet weak var amplitudeLabel: UILabel!
    @IBOutlet weak var detectedNotesLabel: UILabel!
    
    @IBOutlet weak var TerminalCommand: UITextField!
    
    @IBOutlet weak var theButton: UIButton!
    @IBAction func showAlert(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Password Creation", message: "Press 'OK' and sing using the microphone", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertController, animated: true, completion: nil)
        let OKAction = UIAlertAction(title: "OK", style:.default) { (action:UIAlertAction) in
            print("You've pressed OK button");}
        alertController.addAction(OKAction)
        if (firstTime)//global var
        {
            firstTime = false;
            theButton.isHidden = true;

        }
        
    }
    @IBAction func TextFieldEditingChanged(_ sender: UITextField) {
        
        
        print ("hello")
        Processed.text = process(toProcess: self.TerminalCommand.text!)
    }

 
    /*func textFieldDidChange(_textField: UITextField){
        Processed.text = process(toProcess: self.TerminalCommand.text!)
        print (Processed.text)
    }
    */
    
    @IBAction func playPasswordButton(_ sender: UIButton) {
        if (!playingNote) {
            playPassword()
        }
    }
    
    @IBAction func playFirstNoteOfPassword(_ sender: UIButton) {
        
        if (playingNote) {  // If currently playing note and will to stop it...
            stopPlayingNote()
            sender.setTitle("Play Reference Pitch (First note of password)", for: .normal)
        } else {
            playNote(Note: password[0], RaiseOctaveBy: 2)
            sender.setTitle("Stop Playing Reference Pitch", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeAudioKitForMicInput(timeBetweenNotes: timeIntervalBetweenNoteSamples)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // ----------------------------------- Begin AudioKit Stuff ----------------------------------- //
    
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    let noteNamesWithFlats = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
    //let noteNamesCombinedSharpsFlats = ["C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B"]
    let noteNames = ["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"]
    var recordedNotes: [String] = []
    var lastThreeNotesDetected: [String] = ["empty1", "empty2", "empty3"]  // Keep track of last 3 notes recorded to account for voice modulations. Note: Initializations MUST be different values
    let password: [String] = ["G2", "B2", "D3"]
    let timeIntervalBetweenNoteSamples: Double = 0.1
    
    var playingNote: Bool = false
    let notePlayer: AKOscillator = AKOscillator()
    
    
    
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
                
                // Check the recorded notes and see if they match the password
                let passwordCorrect: Bool = checkPassword(thresholdPercentCorrect: 1.0)
                if (passwordCorrect) {
                    passwordStatusLabel.text = "Password: CORRECT!"
                    performSegue(withIdentifier: "passwordAccepted", sender: nil)
                }
                
            }
        }
        amplitudeLabel.text = String("Amplitude: \(tracker.amplitude)")
        
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
    
    func playPassword() {
        timer_playPassword = Timer.scheduledTimer(timeInterval: 0.5,
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
    
    
    func checkPassword(thresholdPercentCorrect threshold: Double) -> Bool {
        
        // If the user has recorded a sufficient number of notes to do the comparison, check the password
        if (recordedNotes.count >= password.count) {
            
            // Check the last "n" notes recorded (where "n" is the # notes in the password) to see if they match the password
            let numberOfNotesInPassword = password.count
            var recordedNotes_PWIndex = recordedNotes.count - numberOfNotesInPassword  // Index "n" notes from the end of the array
            var num_matchingNotes: Int = 0
            for i in 0 ..< numberOfNotesInPassword {
                if (recordedNotes[recordedNotes_PWIndex] == password[i]) {
                    num_matchingNotes += 1
                }
                recordedNotes_PWIndex += 1
            }
            
            let percentMatched: Double = Double(num_matchingNotes) / Double(numberOfNotesInPassword)
            
            if (percentMatched >= threshold) {
                return true
            }
            
        }
        return false
    }
    
    // ----------------------------------- End of AudioKit Stuff ----------------------------------- //
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        recordedNotes = []
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        AKSettings.audioInputEnabled = false
        stopAudioKitMicInput()
    }
    
    
}


