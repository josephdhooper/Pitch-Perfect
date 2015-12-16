//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Joseph Hooper on 11/24/15.
//  Copyright © 2015 josephdhooper. All rights reserved.
//  Note: The code for handeling errors using a do-catch statement was sourced from https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ErrorHandling.html and GitHub repos.

import UIKit
import AVFoundation

    class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate  {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.text = "Tap to record"
    
    }
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
    
    }
    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled = false
        recordingInProgress.text = "Recording"
        stopButton.hidden = false
        print("in recordAudio")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch {}
        
        audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        
        } else {
            print("Recording was not succesful")
            recordButton.enabled = true
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
        @IBAction func stopAudio(sender: UIButton) {
            audioRecorder.stop()
            stopButton.hidden = true
            audioRecorder.pause()
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setActive(false)
            } catch {}
          
        }
    }
