import AuthProvider

final class UserController {
  let drop: Droplet
  let userDispatcher: UserDispatcher
  let tokenDispatcher: TokenDispatcher
  
  init(drop: Droplet) {
    self.drop = drop
    self.userDispatcher = UserDispatcher()
    self.tokenDispatcher = TokenDispatcher()
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
    apiTokenMW.patch("user", handler: update)
  }
  
  /// create user out of a json request
  func register(_ req: Request) throws -> ResponseRepresentable {
    guard let json = req.json else {
      return try Helper.errorJson(status: 406, message: "no json provided")
    }
    
    var user: User
    do { user = try User(json: json) }
    catch { return try Helper.errorJson(status: 406, message: "could not create user with provided json: \(json)")}
    
    if !Helper.validateEmail(user.email) {
      return try Helper.errorJson(status: 406, message: "invalid email")
    }
    
    if !Helper.validatePassword(user.password) {
      return try Helper.errorJson(status: 406, message: "password must contain at least 8 character")
    }
    
    let userExists = try userDispatcher.checkEmailExists(EmailExistRequest(email: user.email))
    if (userExists) {
      return try Helper.errorJson(status: 409, message: "user with email \(user.email) already exists")
    }
    
    var req: RegisterUserRequest
    do { req = try RegisterUserRequest.fromJSON(json) }
    catch { return try Helper.errorJson(status: 406, message: "could not register user with provided json: \(json)") }
    
    guard let res = try userDispatcher.register(req: req) else {
      return try Helper.errorJson(status: 500, message: "could not register user with provided json: \(json)")
    }
    
    return try res.makeJSON()
  }
  
  /// create auth token for user via basic auth
  func login(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.auth.assertAuthenticated(User.self)
    guard let res = try tokenDispatcher.generate(req: SaveTokenRequest(user: user)) else {
      return try Helper.errorJson(status: 500, message: "could not login user")
    }
    
    return try res.makeJSON()
  }
  
  /// delete all auth token for given user
  func logout(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.auth.assertAuthenticated(User.self)
    try Token.makeQuery().filter("user_id", user.id).all().forEach({token in try token.delete()})
    return try JSON(node: ["status": 200, "message": "successfully logged out"])
  }
  
  /// return user by auth token
  func getUser(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.auth.assertAuthenticated(User.self)
    return try user.makeJSON()
  }
  
  /// patch user
  func update(_ req: Request) throws -> ResponseRepresentable {
    guard let json = req.json else {
      return try Helper.errorJson(status: 406, message: "no json provided")
    }
    
    let user = try req.auth.assertAuthenticated(User.self)
    user.firstname = json["firstname"]?.string ?? user.firstname
    user.lastname = json["lastname"]?.string ?? user.lastname
    user.website = json["website"]?.string ?? user.website
    user.company = json["company"]?.string ?? user.company
    
    try user.save()
    return try user.makeJSON()
  }
  
  /// change email
  func updateEmail(_ req: Request) throws -> ResponseRepresentable {
    guard
      let json = req.json,
      let email = json["email"]?.string
    else {
      return try Helper.errorJson(status: 406, message: "no json or email provided")
    }
    
    let user = try req.auth.assertAuthenticated(User.self)
    user.email = email
    try user.save()
    return try user.makeJSON()
  }
}

