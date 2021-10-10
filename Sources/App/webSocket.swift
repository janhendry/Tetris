//
//  File.swift
//  
//
//  Created by Simone Stürenburg on 09.10.21.
//
import Vapor
import JSONCoderIO


var list: [WebSocket] = []

func webSocket(_ app: Application){
   

    let gameSystem = GameSystem(eventLoop: app.eventLoopGroup.next())

    app.webSocket("channel") { req, ws in
        gameSystem.connect(ws)
    }
    
    app.webSocket("screen"){ req, ws in
        TetrisScreens.connect(ws: ws)
    }
    
    app.webSocket("action"){ req, ws in
        ws.onText{ ws ,text in
            ws.send(text)
            print(text)
            if let decoder = try? JSONDecoderIO(text), let action =  try? ActionRequest(from: decoder){
                TetrisModel.action(action)
            }
        }
    }
    
}



