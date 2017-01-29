//
//  ViewController.swift
//  PriorityBattle
//
//  Created by Nabil K on 2017-01-27.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import UIKit

class AddItemController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addItemView: AddItemView!
    
    var items: [Item] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addItemView.delegate = self
        self.tableView.layer.shadowColor = UIColor.black.cgColor
        self.tableView.layer.shadowOpacity = 0.8
        
        self.tableView.layer.borderWidth = 3
        self.tableView.layer.borderColor = UIColor(colorLiteralRed: 51, green: 51, blue: 51, alpha: 1).cgColor
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
        
        self.addItemView.center = self.view.center
        self.addItemView.addItemTextView.text = nil
        
        self.view.addSubview(self.addItemView.shadow!)
        self.view.addSubview(addItemView)
    }
    
    
    @IBAction func beginButton(_ sender: Any) {
        
        if self.items.count < 2{
            let alert = UIAlertController(title: "Not enough options", message: "You must create at least three options", preferredStyle: .alert)
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
        
    
    func dismiss(view: AddItemView) {
        if let shadow = view.shadow{
            shadow.removeFromSuperview()
            view.removeFromSuperview()
        }
        
        else{
            view.removeFromSuperview()
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

