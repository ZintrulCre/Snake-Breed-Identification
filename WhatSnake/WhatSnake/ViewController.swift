//
//  ViewController.swift
//  WhatSnake
//
//  Created by ZintrulCre on 2019/4/1.
//  Copyright © 2019 ZintrulCre. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var table_view: UITableView!
    
    var snake_names: [String] = ["Carpet Python", "Coastal Taipan", "Common Death Adder", "Eastern Brown Snake", "Indian Taipan", "Lowerland Copperhead", "Milk Snake", "Mulga Snake", "Red-Bellied Black Snake", "Spotted Python", "Suta Suta", "Tiger Snake", "Western Brown Snake", "Black-Headed Python", "Bandy Bandy"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table_view.delegate = self
        table_view.dataSource = self
    }
    
    @IBAction func OnCameraButtonTouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "CameraSegue", sender: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.snake_names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = self.snake_names[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.SetLabelName(name: name)
        return cell
    }
}


class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var label_name: UILabel!
    
    func SetLabelName(name: String) {
        self.label_name.text = name
    }
}
