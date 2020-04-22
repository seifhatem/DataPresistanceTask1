//
//  Book.swift
//  Books
//
//  Created by Alaa Maher on 4/21/20.
//  Copyright © 2020 Alaa Maher. All rights reserved.
//

import Foundation

struct Book: Codable {
	var title: String
	var author: String
    
    func covertToCSVFormat()->String{
        return title + "," + author + "\n"
    }
    

}

