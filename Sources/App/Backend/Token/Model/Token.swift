import FluentProvider
import Vapor
import Crypto

final class Token: Model {
  let storage = Storage()
  let token: String
  let userId: Identifier
  
  init(token: String, user: User) throws {
    self.token = token
    self.userId = try user.assertExists()
  }
  
  init(row: Row) throws {
    self.token = try row.get("token")
    self.userId = try row.get(User.foreignIdKey)
  }
  
  func makeRow() throws -> Row{
    var row = Row()
    try row.set("token", token)
    try row.set(User.foreignIdKey, userId)
    return row
  }
}

extension Token: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string("token")
      builder.foreignId(for: User.self)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

/// - create relation to user
extension Token {
  var user: Parent<Token, User> {
    return parent(id: userId)
  }
}

/// - generate random token
/// - initialize model with token and given user
/// - return Token-Object
extension Token {
  static func generate(for user: User) throws -> Token {
    let random = try Crypto.Random.bytes(count: 16)
    return try Token(token: random.base64Encoded.makeString(), user: user)
  }
}

/// - create JSON format
extension Token: JSONRepresentable {
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("token", token)
    return json
  }
}
