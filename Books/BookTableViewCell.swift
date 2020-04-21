//
//  BookTableViewCell.swift
//  Books
//
//  Created by Alaa Maher on 4/21/20.
//  Copyright © 2020 Alaa Maher. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func setTitle(title: String) {
		self.titleLabel.text = title
	}

	func setAuthor(author: String) {
		self.authorLabel.text = author
	}
}
