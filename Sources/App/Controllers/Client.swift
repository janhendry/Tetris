//
//  File.swift
//  
//
//  Created by Simone Stürenburg on 09.10.21.
//

import Vapor
import JSONCoderIO
import Foundation

class WebsocketClients {
    var eventLoop: EventLoop
    var storage: [UUID: WebSocketClient]
    
    var active: [WebSocketClient] {
        storage.values.filter { !$0.socket.isClosed }
    }

    init(eventLoop: EventLoop, clients: [UUID: WebSocketClient] = [:]) {
        self.eventLoop = eventLoop
        self.storage = clients
    }
    
    func add(_ client: WebSocketClient) {
        self.storage[client.id] = client
    }

    func remove(_ client: WebSocketClient) {
        self.storage[client.id] = nil
    }
    
    func find(_ uuid: UUID) -> WebSocketClient? {
        self.storage[uuid]
    }

    deinit {
        let futures = self.storage.values.map { $0.socket.close() }
        try! self.eventLoop.flatten(futures).wait()
    }
}

class WebSocketClient {
    var id: UUID
    var socket: WebSocket

    init(id: UUID, socket: WebSocket) {
        self.id = id
        self.socket = socket
    }
}


struct WebsocketMessage<T: Codable>: Codable {
    let client: UUID
    let data: T
}

extension ByteBuffer {
    func decodeWebsocketMessage<T: Codable>(_ type: T.Type) -> WebsocketMessage<T>? {
        try? JSONDecoder().decode(WebsocketMessage<T>.self, from: self)
    }
}

struct Connect: Codable {
    let connect: Bool
}

class PlayerClient: WebSocketClient {
    

}



class GameSystem {
    var clients: WebsocketClients

    init(eventLoop: EventLoop) {
        self.clients = WebsocketClients(eventLoop: eventLoop)
    }

    func update(){
        clients.active.forEach{
            $0.socket.send("update")
        }
    }
    
    func connect(_ ws: WebSocket) {
        ws.onText{ [unowned self] ws, text in
            do{
                let decoder = try JSONDecoderIO(text)
                let msg = try WebsocketMessage<Connect>(from: decoder)
            
                let player = PlayerClient(id: msg.client, socket: ws)
                self.clients.add(player)
            }catch {
                print(error.localizedDescription)
            }
            update()
            
        }
        
        ws.onBinary { [unowned self] ws, buffer in
            print("onbinary")
            if let msg = buffer.decodeWebsocketMessage(Connect.self) {
                let player = PlayerClient(id: msg.client, socket: ws)
                self.clients.add(player)
            }
        }
    }
}
