//
//  File.swift
//  
//
//  Created by Simone Stürenburg on 09.10.21.
//

import Vapor


class TetrisModel{
    static var users: [String:WebSocket] = [:]
    
    static func login(_ id: String,_ ws: WebSocket) -> Bool{
        if (users[id] != nil ){
            return false
        }
        users[id] = ws
        return true
    }
    
    static func action(_ action: ActionRequest){
        
    }
    
}

struct User{
    let name: String
    var wins: Int
}


struct TetrisJoin{
    let user: String
    let id: String
}


