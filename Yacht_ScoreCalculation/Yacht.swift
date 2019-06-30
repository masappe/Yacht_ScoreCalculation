//
//  Yacht.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/29.
//  Copyright © 2019 masappe. All rights reserved.
//

import Foundation

class boat:NSObject {
    var boatNumber: String!
    var skipper: String!
    var crew: String!
    var currnetCount:Int!
    var totalCount:Int!
    var result:Int!
    
    func insert(first:String,second:String,thrid:String){
        self.boatNumber = first
        self.skipper = second
        self.crew = thrid
    }
    
}

class fourSevenZero:NSObject {
    var list: [boat] = []
    static let shared = fourSevenZero()
    private override init(){}
}

class snipe:NSObject {
    var list: [boat] = []
    static let shared = snipe()
    private override init(){}
    
}

class currentResult:NSObject {
    var list: [boat] = []
    static let shared = currentResult()
    private override init() {}
}
