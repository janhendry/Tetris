//
//  File.swift
//  
//
//  Created by Simone Stürenburg on 10.10.21.
//

import Vapor


class TetrisScreens{
    static var sockets: [WebSocket] = []
    
    static func connect(ws: WebSocket){
        sockets.append(ws)
        ws.onText({ update(text: $1) })
        ws.onClose.whenSuccess{ close() }
    }
    
    static func close(){
        sockets.removeAll(where: {$0.isClosed})
    }
    
    static func update(text: String){
        sockets.forEach{ $0.send(text) }
    }
}


struct Screen: Codable{
    let id:UUID
    let view: [[Int]]
}
