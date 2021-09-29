//
//  Petition.swift
//  Whitehouse Petitions
//
//  Created by Mehar on 27/09/2021.
//

import Foundation

struct Petition: Codable{
    var title: String
    var body: String
    var signatureCount: Int
}
