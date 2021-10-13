//
//  File.swift
//  
//
//  Created by Simone Stürenburg on 09.10.21.
//

import Vapor
import JSONCoderIO


class TetrisController{
    let streamID: String
    var users: [String:User] = [:]
    var isRunning: Bool = false
    
    init(streamID: String){
        self.streamID = streamID
        WebSocketStream.delegate[streamID] = self
    }
    
    func runGame(){
        if !isRunning {
            let ready = users.reduce(false,{ reult, item in
                item.value.isReady ? true : reult
            })
            isRunning = ready
        }else{
            let end = users.reduce(false,{ reult, item in
                item.value.isEnd ? true : reult
            })
            isRunning = !end
            if (end){
                WebSocketStream.update(streamID, data: ActionResponse(action: .gameEnd, data: nil))
            }
        }
        
        if isRunning{
            WebSocketStream.update(streamID, data: ActionResponse(action: .gameTick, data: nil))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.runGame()
            }
        }
        
    }
    
}

extension TetrisController: WebSocketStreamDelegate{
    func connect(_ clientId: String) {
        users[clientId] = User()
    }
    
    func update(text: String) {
        
    }
    
    func close(_ clientId: String) {
        
    }
}

class User{
    var score: Int = 0
    var lastView: String = ""
    var isReady: Bool = false
    var isEnd: Bool = false
    
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
