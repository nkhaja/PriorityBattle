//
//  AddItemView.swift
//  PriorityBattle
//
//  Created by Nabil K on 2017-01-27.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import UIKit

protocol AddItemDelegate: class {
    func getItemsAdded(items:[Item])
    func dismiss(view: AddItemView)
}


class AddItemView: UIView {
   
    
    @IBOutlet weak var seperateItemsLabel: UILabel!
    @IBOutlet weak var addItemTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    var shadow: UIView?
    weak var delegate: AddItemDelegate?
    
    
    // Takes frame of parent view
    override init(frame: CGRect) {
        let h = frame.height * 0.6
        let w = frame.width * 0.9
        let x = frame.midX
        let y = frame.midY
        let itemViewFrame = CGRect(x: 0, y: 0, width: w, height: h)
        super.init(frame: itemViewFrame)
        
        self.center = CGPoint(x: x, y: y)
        self.backgroundColor = UIColor.white
        
        // Shadow for background layer
        self.shadow = UIView(frame: frame)
        shadow!.backgroundColor = UIColor.black.withAlphaComponent(0.6
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func addShadow(view:UIView){
        self.shadow = UIView(frame: view.frame)
        shadow!.backgroundColor = UIColor.black.withAlphaComponent(0.6
        )
    }
    
    
    
    func setupFromStoryBoards(parentView:UIView){
        let h = frame.height * 0.6
        let w = frame.width * 0.9
        let x = frame.midX
        let y = frame.midY
        let itemViewFrame = CGRect(x: 0, y: 0, width: w, height: h)
        
        self.frame = itemViewFrame
        
        self.center = CGPoint(x: x, y: y)
        self.backgroundColor = UIColor.white
        
        // Shadow for background layer
        self.shadow = UIView(frame: frame)
        shadow!.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    
    
    
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        var itemList: [Item] = []
        if addItemTextView.text == "" {return}
        
        if let delegate = self.delegate, let itemNames = addItemTextView.text {
            
            let stringList = itemNames.components(separatedBy: "\n")
            
            for s in stringList{
                
                let noReturns = s.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if noReturns != ""{
                    itemList.append(Item(name: noReturns))
                }
            }
            
            delegate.getItemsAdded(items: itemList)
            delegate.dismiss(view: self)
            
        }
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        if let delegate = delegate{
            delegate.dismiss(view: self)
        }
    }
    
    
}


extension AddItemView: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView){
        
        let text = textView.text.characters
        var count = 0
        
        if text.count > 0{
            count = 1
        }

        for c in text{
            if c == "\n"{
                count+=1
            }
        }
        countLabel.text = String(count)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            self.countLabel.text = String(0)
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
}
