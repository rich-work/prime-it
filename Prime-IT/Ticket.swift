//
//  Ticket.swift
//  Prime-IT
//
//  Created by IT Mac on 1/12/16.
//  Copyright © 2016 IT Mac. All rights reserved.
//

import Foundation

class Ticket {
    
    private var _title: String! = ""
    private var _firstName: String! = ""
    private var _lastName: String! = ""
    private var _customer: String! = ""
    private var _availUser: [String]! = []
    private var _barcode: String! = ""
    private var _category: String! = ""
    private var _comment: String! = ""
    
    var title: String {
        return _title
    }
    var firstName: String {
        return _firstName
    }
    var lastName: String {
        return _lastName
    }
    var customer: String {
        return _customer
    }
    var availUser: [String] {
        return _availUser
    }
    var barcode: String {
        return _barcode
    }
    var category: String {
        return _category
    }
    var comment: String {
        return _comment
    }
    
    init(t: String, fn: String, ln: String, bcode: String, cat: String, com: String) {
        if let titleText = t as? String {
            self._title = titleText
        }
        if let firstName = fn as? String {
            self._firstName = firstName
        }
        if let lastName = ln as? String {
            self._lastName = lastName
        }
        if let addBar = bcode as? String {
            self._barcode = addBar
        }
        if let addCat = cat as? String {
            self._category = addCat
        }
        if let commentText = com as? String {
            self._comment = commentText
        }
    }
    
    func assignUserName(usrNm: String) {
        if let userName = usrNm as? String {
            self._customer = userName
        }
    }
    
    func addAvailUserName(userNm: String) {
        if let availUserName = userNm as? String {
            self._availUser.append(availUserName)
        }
    }
    
    func addBarcode(bcode: String) {
        if let addBar = bcode as? String {
            self._barcode = addBar
        }
    }
    
    func addCategory(cat: String) {
        if let addCat = cat as? String {
            self._category = addCat
        }
    }
    
    func addComment(com: String) {
        if let commentText = com as? String {
            self._comment = commentText
        }
    }
    
    func resetTicket() {
        self._title = ""
        self._firstName = ""
        self._lastName = ""
        self._customer = ""
        self._availUser = []
        self._barcode = ""
        self._category = ""
        self._comment = ""
    }
    
}