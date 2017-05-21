
import UIKit
import AudioKit


class ViewController: UIViewController {

    var firstTime = 0;
    
    
    @IBOutlet weak var Processed: UILabel!
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
        if (firstTime == 0)//global var
        {
            firstTime = 1;
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
    //let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    //let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    //let noteNamesCombinedSharpsFlats = ["C", "C♯/D♭", "D", "D♯/E♭", "E", "F", "F♯/G♭", "G", "G♯/A♭", "A", "A♯/B♭", "B"]
    let noteNames = ["C", "C♯", "D", "E♭", "E", "F", "F♯", "G", "A♭", "A", "B♭", "B"]
    var recordedNotes: [String] = []
    let timeIntervalBetweenNoteSamples: Double = 0.4
    
    var playingNote: Bool = false
    let notePlayer: AKOscillator = AKOscillator()
    
    
    func initializeAudioKitForMicInput(timeBetweenNotes timeInterval: Double) {
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        AudioKit.output = silence
        AudioKit.start()
        Timer.scheduledTimer(timeInterval: timeIntervalBetweenNoteSamples,
                             target: self,
                             selector: #selector(ViewController.updateUI),
                             userInfo: nil,
                             repeats: true)
    }
    
    
    @IBAction func playNote(_ sender: UIButton) {
        AudioKit.stop()  // Note: can stop AK as many times as needed, but can't start AK multiple times in a row without stopping
        notePlayer.amplitude = 0.2
        notePlayer.frequency = 440  // A440
        if (playingNote) {
            
            notePlayer.stop()
            // Restart AudioKit to enable audio input
            initializeAudioKitForMicInput(timeBetweenNotes: timeIntervalBetweenNoteSamples)
            playingNote = false
            sender.setTitle("Play Note: A440", for: .normal)
        } else {
            AudioKit.output = notePlayer
            AudioKit.start()
            notePlayer.start()
            playingNote = true
            sender.setTitle("Stop Playing", for: .normal)
        }
    }
    
    
    func updateUI() {
        if tracker.amplitude > 0.1 {
            
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
            
            // Store the current Note ONLY if it isn't the same as the previous one
            if (recordedNotes.count != 0) {
                if (recordedNotes[recordedNotes.count - 1] != currentNote) {
                    // Add the note name to the array of Recorded Notes
                    recordedNotes.append(currentNote)
                    
                    // Update label for list of all notes sung
                    detectedNotesLabel.text?.append(", \(currentNote)")
                }
            } else {
                recordedNotes.append(currentNote)
                detectedNotesLabel.text?.append(currentNote)
            }
        }
        amplitudeLabel.text = String(format: "%0.2f", tracker.amplitude)
    }
    
    // ----------------------------------- End of AudioKit Stuff ----------------------------------- //
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        recordedNotes = []
    }
    
    
}


