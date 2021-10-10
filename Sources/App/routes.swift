import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "Yeah you get a response from TetrisServer by janehndry!"
    }

     app.get("login"){ req -> LoginResponse in
        let login = try req.content.decode(LoginRequest.self)
        return TetrisModel.login(name: login.name)
    }
    
    app.get("actionn"){ req -> HTTPStatus in
        let action = try req.content.decode(ActionRequest.self)
        return HTTPStatus.ok
        
    }
}

struct LoginRequest: Content{
    let name:String
}


struct LoginResponse: Content{
    let id: String
    let name: String
    let wins: Int
    
    init(id: UUID, _ user: User){
        self.id = id.uuidString
        name = user.name
        wins = user.wins
    }
}

struct ActionRequest : Codable, Content{
    let id: String
    let action: String
}

enum Action:Codable,Content{
    case Join
    case Leaf
    case singleLine
    case doubleLine
}
