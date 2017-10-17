import HTTP
import AuthProvider

final class UserController {
  let drop: Droplet
  let userDispatcher: UserDispatcher
  
  init(drop: Droplet) {
    self.drop = drop
    self.userDispatcher = UserDispatcher()
  }
  
  func setupRoutes() {
    
    /// public
    let api = drop.grouped("api")
    api.post("user", handler: register)
    
    /// password
    let apiPasswordMW = api.grouped([PasswordAuthenticationMiddleware(User.self)])
    apiPasswordMW.post("login", handler: login)
    
    /// token
    let apiTokenMW = api.grouped([TokenAuthenticationMiddleware(User.self)])
    apiTokenMW.get("user", handler: getUser)
    apiTokenMW.post("logout", handler: logout)
  }
  
  /// create user out of json request
  /// - returns on success: json with user
  /// - returns on failure: json with error status + message
  func register(_ req: Request) throws -> ResponseRepresentable {
    guard let json = req.json else {
      return try JSON(node: ["status": 406, "message": "no json provided"])
    }
    
    var user: User
    
    do { user = try User(json: json) }
    catch { return try JSON(node: ["status": 406, "message": "could not create user with provided json: \(json)"]) }
    
    let userExists = try userDispatcher.checkEmailExists(EmailExistRequest(email: user.email))
    
    if (userExists) {
      return try JSON(node: ["status": 409, "message": "user with email \(user.email) already exists"])
    }
    
    user.password = try BCryptHasher().make(user.password.bytes).makeString()
    try user.save()
    return try user.makeJSON()
  }
  
  /// create auth token for user through basic auth
  /// - returns on success: json with token
  /// - returns on failure: json with error (vapors own)
  func login(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.auth.assertAuthenticated(User.self)
    let token = try Token.generate(for: user)
    try token.save()
    return try token.makeJSON()
  }
  
  /// delete all auth token for given user
  func logout(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.auth.assertAuthenticated(User.self)
    try Token.makeQuery().filter("user_id", user.id).all().forEach({token in try token.delete()})
    return try JSON(node: ["status": 200, "message": "successfully logged out"])
  }
  
  /// return user by auth token
  /// - returns on success: user as json
  /// - returns on failure: error as json (vapors own)
  func getUser(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.auth.assertAuthenticated(User.self)
    return try user.makeJSON()
  }
}

