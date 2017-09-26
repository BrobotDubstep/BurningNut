//
//  PlayerCell.swift
//  BurningNut
//
//  Created by Tim Olbrich on 25.09.17.
//  Copyright © 2017 Tim Olbrich. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {

    @IBOutlet weak var playerLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(player: Player) {
      playerLbl.text = player.name
    }
}
