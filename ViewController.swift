//
//  ViewController.swift
//  timer
//
//  Created by Trey Hogan on 10/31/18.
//  Copyright © 2018 Trey Hogan. All rights reserved.
//
import Cocoa
import AVFoundation
import AppKit

class ViewController: NSViewController {
    var seconds = 0;
    var minutes = 0;
    var hours = 0;
    var time = 0;
    var playing = false
    var started = false
    var paused = false
    
    var originalTime = 0;
    
    var timer = Timer()
    
    var player:AVAudioPlayer = AVAudioPlayer()

    @IBOutlet weak var enter: NSTextField!
    @IBOutlet weak var showTime: NSTextField!
    
    @IBAction func start(_ sender: NSButton) {
        seconds = 0
        minutes = 0
        hours = 0
    
        let tokens = enter.stringValue.split(separator: " ")
        
        var index = 0
        for token in tokens{
            if(token.prefix(3) == "sec"){
                if let num = Int(tokens[index - 1]){
                    seconds = num
                }
            }
            if(token.prefix(3) == "min"){
                if let num = Int(tokens[index - 1]){
                    minutes = num
                }
            }
            if(token.prefix(4) == "hour"){
                if let num = Int(tokens[index - 1]){
                    hours = num
                }
            }
            index += 1
        }
        if(enter.stringValue != ""){
            originalTime = seconds + 60*minutes + 3600*hours;
        }
        
        if(!started){
            time = originalTime
            printOutTime()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
        }
        if(started && enter.stringValue != ""){
            time = originalTime
            printOutTime()
        }
        //continues from pause
        if(started && paused){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
            paused = false
        }
        
        started = true
        enter.stringValue = ""
    }
    //pause the clock
    @IBAction func pause(_ sender: NSButton) {
        timer.invalidate()
        paused = true
    }
    //reset the clock to it's original value
    @IBAction func reset(_ sender: NSButton) {
        if(playing){
            player.currentTime = 0
            player.pause()
        }
        timer.invalidate()
        time = originalTime
        started = false
        printOutTime()
    }
    //decrements the clock, plays the sound if done
    @objc func action(){
        time -= 1
        if(time > 0){
            printOutTime()
        }
        else{
            timer.invalidate()
            showTime.stringValue = "DONE"
            player.play()
            playing = true
            //NSSound(named: "Ping")?.play()
            
        }
    }
    //return number with leading zeros if less than 10
    func withZeros(num: Int) -> String{
        if(num < 10){
            let number = "0" + "\(num)";
            return number
        }
        else{
            return "\(num)"
        }
    }
    
    func printOutTime(){
        var secs = time;
        let hrs = (Int)(secs/3600);
        secs -= 3600*hrs;
        let mins = (Int)(secs/60);
        secs -= 60*mins;
        
        if(hrs>0){
            let printOut = "\(hrs):" + withZeros(num: mins) + ":" + withZeros(num: secs);
            showTime.stringValue = printOut;
        }
        else if(mins>0){
            let printOut = "\(mins):" + withZeros(num: secs);
            showTime.stringValue = printOut;
        }
        else{
            let printOut = "\(secs)";
            showTime.stringValue = printOut;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTime.stringValue = "READY"
        do{
            let audioPath = Bundle.main.path(forResource: "animal", ofType: "m4a")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!)as URL)
        }
        catch{
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

