//
//  File.swift
//  
//
//  Created by Simone Stürenburg on 09.10.21.
//
import Vapor
import JSONCoderIO

func webSocket(_ app: Application){
    

    //let gameSystem = GameSystem(eventLoop: app.eventLoopGroup.next())
    app.webSocket("stream",":streamID",":clientID"){ req, ws in
        guard let streamID = req.parameters.get("streamID"), let clientID = req.parameters.get("clientID") else {
            _ = ws.close()
            return
        }
        WebSocketStream.connect(streamID, clientID, ws: ws)
    }
    
    app.webSocket("screen",":clientID"){ req, ws in
        guard let clientID = req.parameters.get("clientID") else{
            _ = ws.close()
            return
        }
        WebSocketStream.connect("Tetris", clientID, ws: ws)
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



