/*
The MIT License (MIT)

Copyright (c) 2014, Sinch - RebTel Networks AB (Swedish company reg. no 556680-3622)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
import UIKit

class MainViewController: UIViewController, SINCallClientDelegate {
    
    @IBOutlet var destination: UITextField!
    @IBOutlet var callButton: UIButton!
    
    func client() -> SINClient {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.client!
    }
    
    @IBAction func call(sender: AnyObject) {
        if !destination.text.isEmpty && client().isStarted() {
            var call: SINCall = client().callClient().callUserWithId(destination.text)
            performSegueWithIdentifier("callView", sender: call);
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var callViewController: CallViewController = segue.destinationViewController as! CallViewController;
        var call = sender as! SINCall
        callViewController.call = call
        call.delegate = callViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        destination!.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func awakeFromNib() {
        client().callClient().delegate = self
    }
    
    func client(client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
        performSegueWithIdentifier("callView", sender: call)
    }
    
    func client(client: SINCallClient!, localNotificationForIncomingCall call: SINCall!) -> SINLocalNotification! {
        let ret = SINLocalNotification()
        ret.alertAction = "Answer"
        ret.alertBody = "Incoming call from " + call.remoteUserId
        return ret;
    }
    
}

