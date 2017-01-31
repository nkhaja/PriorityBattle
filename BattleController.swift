//
//  BattleController.swift
//  PriorityBattle
//
//  Created by Nabil K on 2017-01-28.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import UIKit
import AudioToolbox


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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCombos()
        setTimer()
        currentTime = timeGiven
        
        
//        currentPair = pairs.popLast()
        
        
        labelStandardFrame = self.leftLabel.frame
        
        let tapLeft = UITapGestureRecognizer(target: self, action: #selector(leftTapped))
        let tapRight = UITapGestureRecognizer(target: self, action: #selector(rightTapped))

    
        
        leftView.isUserInteractionEnabled = true
        leftView.addGestureRecognizer(tapLeft)

        leftLabel.isUserInteractionEnabled = true
        leftLabel.addGestureRecognizer(tapLeft)
        leftLabel.isHidden = true
//        leftLabel.text = currentPair!.left.name

        
        rightView.isUserInteractionEnabled = true
        rightView.addGestureRecognizer(tapRight)
        
        rightLabel.isUserInteractionEnabled = true
        rightLabel.addGestureRecognizer(tapRight)
        rightLabel.isHidden = true
//        rightLabel.text = currentPair!.right.name
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func makeCombos(){
        for i in 0 ..< items.count{
            for j in (i+1)..<items.count {
                pairs.append((items[i],items[j]))
            }
        }
//        pairs.append((items[items.count - 2], items.last!))

    }
    
    func tapOccurred(){
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        
        UIView.animate(withDuration: 0.2) {
            let scale = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.leftLabel.transform = scale
            self.rightLabel.transform = scale
        }
        
        if pairs.count > 0{
            currentPair = pairs.popLast()
            currentTime = timeGiven
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
        tapOccurred()
        

    }
    
    func rightTapped(){
        currentPair!.right.score += 1
        tapOccurred()
    }
    
    

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}

// Timer Setup

extension BattleController{
    func setTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func updateTime(){
        if currentTime > 0 {
            currentTime -= 1
            timerLabel.text! = String(currentTime)
        }
            
        else if self.leftLabel.isHidden {
            self.leftLabel.isHidden = false
            self.rightLabel.isHidden = false
            self.timerLabel.text = "Begin!"
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            tapOccurred()
        }
    
        else{
            currentTime = timeGiven
            if timerLabel.text != "Begin!"{
                leftTapped()
            }

            timerLabel.text! = String(currentTime)
        }
    }
}


