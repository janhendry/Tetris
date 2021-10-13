//
//  File.swift
//  
//
//  Created by Simone Stürenburg on 10.10.21.
//

import Vapor
import JSONCoderIO


class WebSocketStream{
    static var sockets: [String:[String:WebSocket]] = [:]
    
    static var delegate: [String:WebSocketStreamDelegate] = [:]
    
    static func connect(_ streamId: String, _ clientId: String, ws: WebSocket){
        delegate[streamId]?.connect(clientId)
       
        if sockets[streamId] == nil{
            sockets[streamId] = [:]
        }
        sockets[streamId]?[clientId] = ws
        print("\(clientId) is login on Stream: \(streamId)!")
        
        ws.onText{
            delegate[streamId]?.update(text: text)
            self.update(streamId, text: $1) }
        ws.onClose.whenSuccess{
            self.delegate[streamId]?.close(clientId)
            print("\(clientId) is logout on Stream: \(streamId)!")
            self.sockets[streamId]?.removeValue(forKey: clientId)
        }
    }
    
    static func update(_ streamId: String, text: String){
        sockets[streamId]?.forEach{ $1.send(text) }
    }
    
    static func update(_ streamID: String,_ clientID: String, text: String){
        sockets[streamID]?[clientID]?.send(text)
    }
    
    static func update(_ streamId: String, _ clientId: String, data: Codable){
        do{
            let encoder = JSONEncoderIO.init()
            try data.encode(to: encoder)
            let json = try encoder.getJson()
            update(streamId,clientId,text: json)
        }catch {
            print("Fail encode Codable ")
            print(error.localizedDescription)
        }
    }
    
    static func update(_ streamId: String, data: Codable){
        do{
            let encoder = JSONEncoderIO.init()
            try data.encode(to: encoder)
            let json = try encoder.getJson()
            update(streamId,text: json)
        }catch {
            print("Fail encode Codable ")
            print(error.localizedDescription)
        }
    }
    
}

protocol WebSocketStreamDelegate{
    
    func connect( _ clientId: String)
    
    func update(text: String)
    
    func close( _ clientId: String)
        
}
