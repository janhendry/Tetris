//
//  File.swift
//  
//
//  Created by Simone Stürenburg on 09.10.21.
//

import Vapor
import JSONCoderIO


class TetrisController{
    
    static var isRunning = false
    
    static var users: [String:User] = [:]
    
    static func login(_ id: String,_ ws: WebSocket) -> Bool{
        if (users[id] != nil ){ return false }
        users[id] = User(id, ws, "")
        
        ws.onText{ onText($1) }
        ws.onClose.whenSuccess{ users.removeValue(forKey: id) }
        
        return true
    }
    
    static func updateView(_ id: String) -> Bool{
        guard let user = users[id] else { return false }
        users.forEach{ user.webSocket.send($1.lastView)}
        return true
    }
    
    static func send(id: String, data: Codable){
        do{
            let encoder = JSONEncoderIO.init()
            try data.encode(to: encoder)
            let json = try encoder.getJson()
            send(id, json)
        }catch {
            print("Fail encode Codable")
            print(error.localizedDescription)
        }
    }
    
    static func sendAll(data: Codable){
        do{
            let encoder = JSONEncoderIO.init()
            try data.encode(to: encoder)
            let json = try encoder.getJson()
            sendAll(json)
        }catch {
            print("Fail encode Codable")
            print(error.localizedDescription)
        }
    }
    
    static func send(_ id: String, _ string: String){
        users[id]?.webSocket.send(string)
    }
    
    static func sendAll(_ string: String){
        users.forEach{ $1.webSocket.send(string) }
    }
    
    static private func onText(_ text: String){
        do{
            let decoder = try JSONDecoderIO(text)
            let req = try ActionRequest(from: decoder)
            
            switch req.action {
                case .updateView:
                    _ = updateView(req.id)
                case .singleLine:
                    users[req.id]?.score += 1
                case .doubleLine:
                    users[req.id]?.score += 2
                case .tripleLine:
                    users[req.id]?.score += 4
                case .quadLine:
                    users[req.id]?.score += 6
                case .ready:
                    users[req.id]?.isReady = true
                case .end:
                    users[req.id]?.isEnd = true
            }
        }catch {}
    }
    
    static func runGame(){
        
        if !isRunning {
            let ready = users.reduce(false,{ reult, item in
                item.value.isReady ? true : reult
            })
            isRunning = ready
        }else{
            let end = users.reduce(false,{ reult, item in
                item.value.isEnd ? true : reult
            })
            isRunning = end
            sendAll(data: ActionResponse(action: .gameEnd, data: nil))
        }
        
        
        if isRunning{
            sendAll(data: ActionResponse(action: .gameTick, data: nil))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                runGame()
            }
        }
        
    }
    
}

class User{
    let name: String
    var score: Int
    let webSocket: WebSocket
    var lastView: String
    var isReady: Bool = false
    var isEnd: Bool = false
    
    init(_ name : String, _ ws: WebSocket, _ view: String){
        self.name = name
        self.webSocket = ws
        self.lastView = view
        self.score = 0
    }
}

struct ActionRequest: Codable{
    let id: String
    let action: Action
    
    
    enum Action: Int, Codable {
        case updateView
        case singleLine
        case doubleLine
        case tripleLine
        case quadLine
        case ready
        case end
    }
}

struct ActionResponse: Codable{
    let action: Action
    let data: String?
    
    enum Action: Int, Codable {
        case updateView
        case insertLine
        case gameEnd
        case gameTick
        
    }
    
    struct UpdateView: Codable{
        let id: String
        let view: [[Color]]
    }
    
    struct InsertLines: Codable{
        let lines: [[Color]]
    }
}

enum Color: Int, Codable {
    case Black
    case DarkBlue
    case Red
    case Green
    case Blue
    case Orange
    case Yellow
    case Purple
    case Preview
    case Block
}
