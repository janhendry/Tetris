//
//  File.swift
//  
//
//  Created by Simone Stürenburg on 10.10.21.
//

import Vapor


class TetrisScreens{
    static var sockets: [String:WebSocket] = [:]
    
    static func connect(id: String,ws: WebSocket){
        sockets[id] = ws
        
        print("log in \(id)")
        
        sockets.forEach{ print($0) }
        ws.onText{update(id, text: $1) }
        ws.onClose.whenSuccess{ sockets.removeValue(forKey: id)}
    }
   
    static func update(_ id: String, text: String){
        sockets.forEach{ $1.send(text) }
    }
}
