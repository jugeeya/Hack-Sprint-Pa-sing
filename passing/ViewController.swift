
import UIKit



class ViewController: UIViewController {

    var firstTime = 0;
    
    @IBOutlet weak var Processed: UILabel!
    
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
        
        //alertController.addAction(OKAction)
        
        //self.presentViewController(alertController, animated: true, completion:nil)

        
       /* TerminalCommand.addTarget(self, action: "textFieldDidChange:", for: .editingChanged)
        
        */
        
       /* if let TerminalCommand = self.TerminalCommand.text
        {
            Processed.text = process(toProcess: self.TerminalCommand.text!)
        }*/
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   }


