import Vapor
import FluentProvider

final class Topic: Model {
  let storage = Storage()
  let description: String
  let userId: Int
  
  init(description: String, userId: Int) {
    self.description = description
    self.userId = userId
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
    let description = try json.get("description") as String
    let userId = try json.get("userid") as Int
    let user = try User.find(userId)
    self.init(description: description, userId: user!.id!.int!)
  }
  
  func makeJSON() throws -> JSON {
    let votesCount = try votes.all().count
    let voter = try votes.all().map {user in user.id!.int}
    var json = JSON()
    try json.set("id", id!.int)
    try json.set("description", description)
    try json.set("creatorId", userId)
    try json.set("votes", votesCount)
    try json.set("voter", voter)
    return json
  }
}

// MARK: Votes

extension Topic {
  var votes: Siblings<Topic, User, Pivot<Topic, User>> {
    return siblings()
  }
}
