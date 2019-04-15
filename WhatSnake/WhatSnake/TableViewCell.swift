//
//  TableViewCell.swift
//  WhatSnake
//
//  Created by ZintrulCre on 2019/4/15.
//  Copyright © 2019 ZintrulCre. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var label_name: UILabel!
    
    func SetLabelName(name: String) {
        self.label_name.text = name
    }
}
