import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "Yeah you get a response from TetrisServer by janehndry!"
    }
//    
//    app.get("updateStream",":id"){ req -> HTTPStatus in
//        guard let id = req.parameters.get("id") else {
//            return HTTPStatus.internalServerError
//        }
//        return .updateView("Tetris",id) ? HTTPStatus.ok : HTTPStatus.badRequest
//    }
    
    
    
//    app.get("action"){ req -> HTTPStatus in
//        let action = try req.content.decode(ActionRequest.self)
//        return HTTPStatus.ok
//        
//    }
}

struct LoginRequest: Content{
    let name:String
}


struct LoginResponse: Content{
    let id: String
    let name: String
    
    init(id: UUID, _ user: User){
        self.id = id.uuidString
        name = user.name
    }
}
