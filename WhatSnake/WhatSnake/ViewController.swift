//
//  ViewController.swift
//  WhatSnake
//
//  Created by ZintrulCre on 2019/4/1.
//  Copyright © 2019 ZintrulCre. All rights reserved.
//

import UIKit

struct Snake: Decodable{
    var name: String
    var venomous: Bool
    var distribution: String
    var description: String
}

class ViewController: UIViewController {
    @IBOutlet weak var table_view: UITableView!

    var txts: [String] =  ["CarpetPython", "CoastalTaipan", "CommonDeathAdder", "EasternBrownSnake", "IndianTaipan", "LowlandCopperhead", "MulgaSnake", "RedBelliedBlackSnake", "SpottedPython", "SutaSuta", "TigerSnake", "WesternBrownSnake", "BlackHeadedPython", "BandyBandy"]

    var snakes: [Snake] = []
    var snake: Snake? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txts.sort()
        for txt in txts {
            let file = Bundle.main.path(forResource: txt, ofType: "json")
            do {
                let content = try String(contentsOfFile: file!, encoding: String.Encoding.utf8)
                let data = content.data(using: .utf8)!
                let snake = try JSONDecoder().decode(Snake.self, from: data)
                print(snake.name)
                snakes.append(snake)
            } catch let error as NSError {
                print(error)
            }
        }
        
        table_view.delegate = self
        table_view.dataSource = self
    }
    
    @IBAction func OnDetectionButtonTouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "DetectionSegue", sender: nil)
    }
    
    @IBAction func OnCameraButtonTouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "CameraSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplaySegue" {
            let display_view = segue.destination as! DisplayViewController
            display_view.snake = self.snake
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.snakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = self.snakes[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.SetLabelName(name: name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.snake = snakes[indexPath.row]
        performSegue(withIdentifier: "DisplaySegue", sender: nil)
    }
}


class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var label_name: UILabel!
    
    func SetLabelName(name: String) {
        self.label_name.text = name
    }
}
