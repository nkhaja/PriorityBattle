//
//  ResultsController.swift
//  PriorityBattle
//
//  Created by Nabil K on 2017-01-28.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import UIKit

class ResultsController: UIViewController {
    
    
    var items: [Item] = []
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        items.sort { $0.score > $1.score}

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: { [unowned self] in
            for i in self.items{
                i.score = 0
            }
            
        })
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension ResultsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultCell
        
        cell.itemNameLabel.text = items[indexPath.row].name
        cell.scoreLabel.text = String(items[indexPath.row].score)
        
        return cell
    }
    
    
}
