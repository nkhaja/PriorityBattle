//
//  ViewController.swift
//  PriorityBattle
//
//  Created by Nabil K on 2017-01-27.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import UIKit

class AddItemController: UIViewController {
    
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addItemView: AddItemView!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    var items: [Item] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addItemView.delegate = self
        
        
        beginButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        beginButton.layer.shadowColor = UIColor.black.cgColor
        beginButton.layer.shadowOpacity = 0.5
        beginButton.layer.cornerRadius = 10
        
        addItemButton.imageView?.contentMode = .scaleAspectFit
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func shuffleArray<T>(array: [T]) -> [T] {
        
        var tempArray = array
        for i in 0...array.count - 1 {
            let randomNumber = arc4random_uniform(UInt32(array.count - 1))
            let randomIndex = Int(randomNumber)
            if i != randomIndex{
                swap(&tempArray[i], &tempArray[randomIndex])
            }
            
        }
        
        return tempArray
    }

    
    @IBAction func addItemButton(_ sender: Any) {
        
        self.addItemView.addShadow(view: self.view)
//        self.addItemView.center = CGPoint(x: self.view.center.x, y: self.view.frame.height*1.5)
//        self.addItemView.center = self.view.center
        self.addItemView.frame.origin = self.view.frame.origin
        
        self.addItemView.addItemTextView.text = "Add Items Here"
        self.addItemView.addItemTextView.textColor = UIColor.gray
        self.addItemView.addItemTextView.delegate = addItemView
        
        self.view.addSubview(self.addItemView.shadow!)
        self.view.addSubview(addItemView)
        
        
        
        let scaleUp = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.addItemView.transform = scaleUp
        self.addItemView.layer.opacity = 0
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 2, options: [], animations: {
            self.addItemView.layer.opacity = 1
            self.addItemView.transform = CGAffineTransform.identity
        }, completion: { complete in
            self.addItemView.addItemTextView.becomeFirstResponder()
        })
        
  
        
        
//        UIView.animate(withDuration: 0.2) {
//            self.addItemView.layer.opacity = 1
//            self.addItemView.transform = CGAffineTransform.identity
//            
//        }
        // Position on screen
        // translate down y + 600
        // scale down 0.5
        
        
//        UIView.animate(withDuration: 0.3) { [unowned self] in
//            
//            let moveUp = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
//            self.addItemView.transform = moveUp
//        }
    }
    
    
    @IBAction func beginButton(_ sender: Any) {
        
        if self.items.count < 2{
            let alert = UIAlertController(title: "Not enough items", message: "You must add at least three items", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let battleVC = storyboard.instantiateViewController(withIdentifier: "BattleController") as! BattleController
        battleVC.items = shuffleArray(array: items)
        
        self.present(battleVC, animated: true, completion: nil)
    
    }
}


extension AddItemController: AddItemDelegate{
    
    
    func getItemsAdded(items: [Item]) {
        for i in items{
            self.items.append(i)
        }
        tableView.reloadData()
    }
        
    
    func dismiss(view: AddItemView){
        
        UIView.animate(withDuration: 0.3, animations:{
            
            let move = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            view.transform = move
        }) { completed in
            
            if let shadow = view.shadow{
                shadow.removeFromSuperview()
                view.removeFromSuperview()
            }
                
            else{
                view.removeFromSuperview()
            }
            
            view.transform = CGAffineTransform.identity

        }
        
    }
    
    
    
    
}

extension AddItemController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemTableCell
        
        cell.itemLabel.text = items[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [unowned self] action, indexPath in
            self.items.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        return [delete]
    }
}

