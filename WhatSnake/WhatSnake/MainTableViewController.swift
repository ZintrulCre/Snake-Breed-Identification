//
//  MainTableViewController.swift
//  WhatSnake
//
//  Created by ZintrulCre on 2019/4/15.
//  Copyright © 2019 ZintrulCre. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let cellId = "cell id"

    var areas = ["Victoria", "New South Wales", "Northern Territory", "Western Australia", "South Australia", "Queensland", "Tasmania"]
    
    var names = ["Carpet Python", "Coastal Taipan", "Common Death Adder", "Eastern Brown Snake", "Indian Taipan", "Lowerland Copperhead", "Milk Snake", "Mulga Snake", "Red-Bellied Black Snake", "Spotted Python", "Suta Suta", "Tiger Snake", "Western Brown Snake", "Black-Headed Python", "Bandy Bandy"]
    
    @objc func PerformSegue() {
        Test()
    }
    
    func Test() {
        performSegue(withIdentifier: "TestSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        names.sort()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Camera", style: .plain, target: self, action: #selector(PerformSegue))
        navigationItem.title = "Snake Breeds"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Area"
        label.backgroundColor = UIColor.lightGray
        return label
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let name = self.names[indexPath.row]
        cell.textLabel?.text = name
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
