//
//  BattleController.swift
//  PriorityBattle
//
//  Created by Nabil K on 2017-01-28.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation



class BattleController: UIViewController {
    
    

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var dimissButton: UIButton!
    
    
    var items: [Item] = []
    var pairs: [(Item, Item)] = []
    
    var timer: Timer?
    var timeGiven = 3
    var currentTime: Int = 0
    var currentPair:(left:Item, right:Item)?
    var invisibleRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var labelStandardFrame: CGRect?
    var firstPass: Bool = true
    var secondPass: Bool = true
    var defaultColor: UIColor?
    let greenColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    

    
    
    // Sound variables
    var soundEffect: AVAudioPlayer?
    var lowBeepUrl:URL = URL(fileURLWithPath: Bundle.main.path(forResource: "low_beep.wav", ofType: nil)!)
    var highBeepUrl: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "high_beep.wav", ofType: nil)!)
    
    
    var feedbackGenerator: UINotificationFeedbackGenerator?
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCombos()
        setTimer()
        currentTime = timeGiven
        defaultColor = timerLabel.textColor
        dimissButton.imageView?.contentMode = .scaleAspectFit
        feedbackGenerator = UINotificationFeedbackGenerator()

        
        
        
        labelStandardFrame = self.leftLabel.frame
        
        let tapLeft = UITapGestureRecognizer(target: self, action: #selector(leftTapped))
        let tapRight = UITapGestureRecognizer(target: self, action: #selector(rightTapped))

    
        
        leftView.isUserInteractionEnabled = true
        leftView.addGestureRecognizer(tapLeft)

        leftLabel.isUserInteractionEnabled = true
        leftLabel.addGestureRecognizer(tapLeft)
        leftLabel.isHidden = true

        
        rightView.isUserInteractionEnabled = true
        rightView.addGestureRecognizer(tapRight)
        
        rightLabel.isUserInteractionEnabled = true
        rightLabel.addGestureRecognizer(tapRight)
        rightLabel.isHidden = true
        

        leftView.layer.borderColor = greenColor.cgColor
        leftView.layer.borderWidth = 5
        
        rightView.layer.borderColor = greenColor.cgColor
        rightView.layer.borderWidth = 5
        
        }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopSound()
    }
    
    func makeCombos(){
        for i in 0 ..< items.count{
            for j in (i+1)..<items.count {
                pairs.append((items[i],items[j]))
            }
        }

    }
    
    
    func tapOccurred(){
        
        
        feedbackGenerator?.prepare()
        feedbackGenerator!.notificationOccurred(.success)
    
        
        UIView.animate(withDuration: 0.2) {
            let scale = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.leftLabel.transform = scale
            self.rightLabel.transform = scale
        }
        
        if pairs.count > 0 {
            currentPair = pairs.popLast()
            currentTime = timeGiven
            timerLabel.textColor = greenColor
            timerLabel.text = String(currentTime)
            
            self.leftLabel.text = currentPair!.left.name
            self.rightLabel.text = currentPair!.right.name
        }
        
        else{
            timer!.invalidate()
            timerLabel.text = "Complete"
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let resultsVc = storyboard.instantiateViewController(withIdentifier: "ResultsController") as! ResultsController
            resultsVc.items = self.items
            
            self.dismiss(animated: true, completion: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController!.present(resultsVc, animated: true, completion: nil)
            })
            
        }
        

        
        
        
        UIView.animate(withDuration: 0.2) {
            let scale = CGAffineTransform(scaleX: 1, y: 1)
            self.leftLabel.transform = scale
            self.rightLabel.transform = scale
        }
        

    }
    
    func leftTapped(){
        currentPair!.left.score += 1
        triggerTapAnimation(tappedView: leftView)
        tapOccurred()
        

    }
    
    func rightTapped(){
        currentPair!.right.score += 1
        triggerTapAnimation(tappedView: rightView)
        tapOccurred()
    }
    
    func makeSound(url: URL){
        do {
        let sound = try AVAudioPlayer(contentsOf: url)
        self.soundEffect = sound
        sound.play()
        }
        
        catch {
        // couldn't load file :(
        }
    
    }
    
    func stopSound(){
        if soundEffect != nil {
            soundEffect!.stop()
            soundEffect = nil
        }
    }
    
    func triggerTapAnimation(tappedView: UIView){
        let startColor = tappedView.backgroundColor
        
        
        UIView.animate(withDuration: 0.1) {
            let transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            tappedView.backgroundColor = UIColor.gray
            tappedView.transform = transform
        }
        
        UIView.animate(withDuration: 0.1) {
            tappedView.backgroundColor = startColor
            tappedView.transform = CGAffineTransform.identity
            
        }
        
        
    }






    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.timer?.invalidate()
    }
    
    

}

// Timer Setup

extension BattleController{
    func setTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func updateTime(){
    
        if firstPass{
            timerLabel.text = "Begin!"
            makeSound(url: highBeepUrl)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            firstPass = false
            currentPair = pairs.popLast()
            
            leftLabel.isHidden = false
            leftLabel.text = currentPair!.left.name
            
            rightLabel.isHidden = false
            rightLabel.text = currentPair!.right.name
        }
         
        else if currentTime > 1{
            currentTime -= 1
            timerLabel.text! = String(currentTime)
            makeSound(url: lowBeepUrl)
        }
            
        else if currentTime == 1 {
            currentTime -= 1
            timerLabel.text! = String(currentTime)
            timerLabel.textColor = UIColor.red
            makeSound(url: lowBeepUrl)
        }
            
        
        else{
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            timerLabel.textColor = defaultColor
            currentTime = timeGiven
            timerLabel.text! = String(currentTime)
            leftTapped()
            makeSound(url: highBeepUrl)

        }
    }
}


