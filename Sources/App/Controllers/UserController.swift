import Vapor
import HTTP

final class UserController {

  lazy var userDispatcher = UserDispatcher()
  
  func register(_ req: Request) throws -> ResponseRepresentable {
    guard let json = req.json else {
      return try JSON(node: ["status": 406, "message": "no json provided"])
    }
    
    var user: User
    
    do {
      user = try User(json: json)
    } catch {
      return try JSON(node: ["status": 406, "message": "could not create user with provided json: \(json)"])
    }
    
    let userExists = try userDispatcher.checkEmailExists(EmailExistRequest(email: user.email))
    
    if (userExists) {
      return try JSON(node: ["status": 409, "message": "user with email \(user.email) already exists"])
    } else {
      try user.save()
    }
    
    return try user.makeJSON()
  }
}
