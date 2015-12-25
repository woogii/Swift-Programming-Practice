//
//  PlaySoundsViewController.swift
//  Pick Your Pitch
//
//  Created by Udacity on 1/5/15.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // Mark : - Properties 
    
    let SliderValueKey = "Slider Value Key"
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var filePathUrl : NSURL!
    
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // Mark : - View Cycle
    
    override func viewWillAppear(animated: Bool) {
        let slideValue =  NSUserDefaults.standardUserDefaults().objectForKey(SliderValueKey) as? Float
        if let slideValue = slideValue {
            sliderView.value = slideValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        } catch _ {
            audioPlayer = nil
        }
        audioPlayer.enableRate = true

        audioEngine = AVAudioEngine()
        do {
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl)
        } catch _ {
            audioFile = nil
        }
        
        setUserInterfaceToPlayMode(false)
    }
    

    // Mark : - UI components setting 
    
    func setUserInterfaceToPlayMode(isPlayMode: Bool) {
        startButton.hidden = isPlayMode
        stopButton.hidden = !isPlayMode
        sliderView.enabled = !isPlayMode
    }
    
    // Mark : - Action
    @IBAction func playAudio(sender: UIButton) {
        
        // Get the pitch from the slider
        let pitch = sliderView.value
        
        // Play the sound
        playAudioWithVariablePitch(pitch)
        
        // Set the UI
        setUserInterfaceToPlayMode(true)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func sliderDidMove(sender: UISlider) {
        // Do nothing?
        print("Slider value: \(sliderView.value)")
        // Sets the value of the specified default key in the standard application domain
        NSUserDefaults.standardUserDefaults().setObject(sliderView.value, forKey: SliderValueKey)
        
    }
    
    @IBAction func deleteAudioFile(sender: UIButton) {
        
        if let filePathUrl = filePathUrl {
            print("There is no existing file")
        }
    }
    // Mark : - Play Audio 
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil) {
            // When the audio completes, set the user interface on the main thread
            dispatch_async(dispatch_get_main_queue()) {self.setUserInterfaceToPlayMode(false) }
        }
        
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
    }
    

}
