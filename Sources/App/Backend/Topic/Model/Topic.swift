import Vapor
import FluentProvider

final class Topic: Model {
  let storage = Storage()
  let description: String
  let userId: Identifier
  
  init(description: String, user: User) {
    self.description = description
    
    // todo: guard let
    self.userId = user.id!
  }
  
  init(row: Row) throws {
    description = try row.get("description")
    userId = try row.get(User.foreignIdKey)
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set("description", description)
    try row.set(User.foreignIdKey, userId)
    return row
  }
}

// MARK: Preparation

extension Topic: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string("description")
      builder.foreignId(for: User.self)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: Json

extension Topic: JSONConvertible {
  convenience init(json: JSON) throws {
    try self.init(
      description: json.get("description"),
      // todo: refactore force unwrapping
      user: User.find(json.get("userid"))!
    )
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("id", id!.int)
    try json.set("description", description)
    return json
  }
}

// MARK: Votes

extension Topic {
  var users: Siblings<Topic, User, Pivot<Topic, User>> {
    return siblings()
  }
}
