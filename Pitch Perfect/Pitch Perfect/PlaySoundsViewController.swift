//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Joseph Hooper on 11/24/15.
//  Copyright © 2015 josephdhooper. All rights reserved.
//  Note: The code for handeling errors using a do-catch statement was sourced from https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ErrorHandling.html and GitHub repos.

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, fileTypeHint: nil)
        } catch {}
        
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        
        do {
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl!)
        } catch {}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioWithVariableRate(rate: Float) {
        stopAllAudio()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariableRate(0.3)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableRate(2.0)
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAllAudio()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
        } catch {}
        
        audioPlayerNode.play()
        
        }
    }
