//
//  RecordSoundsViewController.swift
//  Pick Your Pitch
//
//  Created by Udacity on 1/5/15.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK : - Properties
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var shouldSegueToSoundPlayer = false
    let fileName = "userVoice.wav"
    
    
    // MARK : - Convenience method which returns file URL
    var fileURL : NSURL {
        
        // defaultManager function returns the shared file manager object for the process.
        // URLsForDirectory:inDomains:  returns an array of URLs for the speicified common directory in the requested domains
        // NSSearchPathDirectory specifies the location of a variety of directories
        // NSSearchPathDomainMask : search path domain constant specifying base locations for the NSSearchPathDirectory type
        // NSUerDomainMask : The user's home directory
        
        let documentUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        // Returns a new URL made by appending a path component to the original URL.
        return documentUrl.URLByAppendingPathComponent(fileName)
    }

    // MARK : - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        //Hide the stop button
        stopButton.hidden = true
        recordButton.enabled = true
    
        // if the recorded file exists
        if NSFileManager().fileExistsAtPath(fileURL.path!) {
            print("Recorded file already exists!")
            shouldSegueToSoundPlayer = true
            // Create audio instance based on information from an existing file
            recordedAudio = RecordedAudio(filePathUrl: fileURL, title: fileName)
            // Perform segue without recording in this view 
            self.performSegueWithIdentifier( "stopRecording", sender: self)
        } else {
            print("There is no recorded file in directory")
        }
    }
    
   
    // MARK : - Action
    @IBAction func recordAudio(sender: UIButton) {
        
        // Update the UI
        stopButton.hidden = false
        recordingInProgress.hidden = false
        recordButton.enabled = false
        
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        // Create the path to the file.
        // let filename = "usersVoice.wav"
        // Returns an array containing the user documents directory as the first object.
        // let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        // let pathArray = [dirPath, filename]
        // Initializes and returns a newly created NSURL object as a file URL with specified path components
        // let fileURL =  NSURL.fileURLWithPathComponents(pathArray)!

        // Initialize and prepare the recorder
        do {
            try audioRecorder = AVAudioRecorder(URL: fileURL, settings: [String : AnyObject]())
        } catch _ {}

        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()

        audioRecorder.record()
            
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance();
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
        
        // This function stops the audio. We will then wait to hear back from the recorder,
        // through the audioRecorderDidFinishRecording method
    }

    
    // Mark : - Finish Recording
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {

        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.pathExtension)
            self.performSegueWithIdentifier("stopRecording", sender: self)
        } else {
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    // Mark : - Prepare Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "stopRecording" {
        
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = recordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
 }

