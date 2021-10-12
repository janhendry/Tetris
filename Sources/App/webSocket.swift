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
    
    
    //let gameSystem = GameSystem(eventLoop: app.eventLoopGroup.next())
    
    app.webSocket("screen",":id"){ req, ws in
        if let id = req.parameters.get("id") {
            TetrisScreens.connect(id: id, ws: ws)
        }else{
            ws.close()
        }
    }
    
//    app.webSocket("action"){ req, ws in
//        ws.onText{ ws ,text in
//            ws.send(text)
//            print(text)
//            if let decoder = try? JSONDecoderIO(text), let action =  try? ActionRequest(from: decoder){
//                TetrisModel.action(action)
//            }
//        }
//    }
    
}



