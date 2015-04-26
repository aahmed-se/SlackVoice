//
//  CallViewController.swift
//  TriumpSlack2
//
//  Created by Ali Ahmed on 4/17/15.
//  Copyright (c) 2015 Triumph labs. All rights reserved.
//

import UIKit

class CallViewController: UIViewController, SINCallDelegate {
    
    @IBOutlet var remoteUsername: UILabel!
    @IBOutlet var callStateLabel: UILabel!
    @IBOutlet var answerButton: UIButton!
    @IBOutlet var declineButton: UIButton!
    @IBOutlet var endCallButton: UIButton!
    
    var call: SINCall?
    
    @IBAction func accept(sender: AnyObject) {
        stopRingtone()
        call!.answer()
    }
    
    @IBAction func decline(sender: AnyObject) {
        call!.hangup()
        dismissViewControllerAnimated(true, completion: {() -> Void in return})
    }
    
    @IBAction func hangup(sender: AnyObject) {
        call!.hangup()
        dismissViewControllerAnimated(true, completion: {() -> Void in return})
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        remoteUsername.text = call!.remoteUserId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dir = call!.direction
        if dir == SINCallDirection.Incoming {
            setCallStatusText("")
            showButtons("Incoming")
            playRingtone("incoming.wav")
        } else {
            setCallStatusText("Calling")
            showButtons("Outgoing")
        }
    }
    
    func callDidProgress(call: SINCall) {
        setCallStatusText("Ringing")
        playRingtone("ringback.wav")
    }
    
    func callDidEstablish(call: SINCall) {
        stopRingtone()
        setCallStatusText("Established")
        showButtons("hangup")
    }
    
    func callDidEnd(call: SINCall) {
        stopRingtone()
        dismissViewControllerAnimated(true, completion: {() -> Void in return;})
    }
    
    func playRingtone(file: String) {
        getAudioController().startPlayingSoundFile(getPathForSound(file), loop: true)
    }
    
    func stopRingtone() {
        getAudioController().stopPlayingSoundFile()
    }
    
    func getAudioController() -> SINAudioController {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).client!.audioController()
    }
    
    func getPathForSound(soundName: String) -> String {
        return NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent(soundName)
    }
    
    func setCallStatusText(text: String) {
        callStateLabel.text = text;
    }
    
    func showButtons(text: String) {
        if text == "Incoming" {
            answerButton.hidden = false
            declineButton.hidden = false
            endCallButton.hidden = true
        } else {
            answerButton.hidden = true
            declineButton.hidden = true
            endCallButton.hidden = false
        }
    }
}
