
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
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    //let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    //let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    //let noteNamesCombinedSharpsFlats = ["C", "C♯/D♭", "D", "D♯/E♭", "E", "F", "F♯/G♭", "G", "G♯/A♭", "A", "A♯/B♭", "B"]
    let noteNames = ["C", "C♯", "D", "E♭", "E", "F", "F♯", "G", "A♭", "A", "B♭", "B"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AudioKit.output = silence
        AudioKit.start()
        Timer.scheduledTimer(timeInterval: 0.1,
                             target: self,
                             selector: #selector(ViewController.updateUI),
                             userInfo: nil,
                             repeats: true)
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
            detectedNotesLabel.text = "\(noteNames[index])\(octave)"
        }
        amplitudeLabel.text = String(format: "%0.2f", tracker.amplitude)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   }


