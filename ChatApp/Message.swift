//
//  Message.swift
//  ChatApp
//
//  Created by Fatih Oğuz on 2.10.2024.
//

import Foundation

struct Message: Decodable {
    let text: String
    let photoURL: String
    let uid: String
    let cratedAt: Date
}
