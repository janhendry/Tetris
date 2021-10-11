//
//  File.swift
//  
//
//  Created by Simone Stürenburg on 09.10.21.
//

import Vapor


class TetrisModel{
    static var users: [UUID:User] = [:]
    
    static func login(name: String) -> LoginResponse{
        let id = UUID()
        let newUser = User(name: name, wins: 0)
        users[id] = newUser
        return .init(id: id, newUser)
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


