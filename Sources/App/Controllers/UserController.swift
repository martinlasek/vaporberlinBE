import Vapor
import HTTP
import AuthProvider

final class UserController {

  lazy var userDispatcher = UserDispatcher()
  
  /// create user out of json request
  /// - returns on success: json with user
  /// - returns on failure: json with error status + message
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
      user.password = try BCryptHasher().make(user.password.bytes).makeString()
      try user.save()
    }
    
    return try user.makeJSON()
  }
  
  /// authenticate user through basic auth
  /// - returns on success: json with token
  /// - returns on failure: json with error (vapors own)
  func login(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.auth.assertAuthenticated(User.self)
    let token = try Token.generate(for: user)
    try token.save()
    return try token.makeJSON()
  }
  
  /// authenticate user through token
  /// - returns on success: user as json
  /// - returns on failure: error as json (vapors own)
  func user(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.auth.assertAuthenticated(User.self)
    return try user.makeJSON()
  }
}
