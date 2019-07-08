//
//  TarifasTableViewCell.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 08/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit

class TarifasTableViewCell: UITableViewCell {
    
    //MARK:properties
    @IBOutlet weak var tarifa: UILabel!
    @IBOutlet weak var desde: UILabel!
    @IBOutlet weak var hasta: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
