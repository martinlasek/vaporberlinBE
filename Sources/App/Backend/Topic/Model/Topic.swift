import Vapor
import FluentProvider

final class Topic: Model {
  let storage = Storage()
  let description: String
  let userId: Int
  var meetupId: Int?
  var presenterId: Int?
  
  init(description: String, userId: Int, meetupId: Int? = nil, presenterId: Int? = nil) {
    self.description = description
    self.userId = userId
    self.meetupId = meetupId
    self.presenterId = presenterId
  }
  
  init(row: Row) throws {
    description = try row.get("description")
    userId = try row.get(User.foreignIdKey)
    meetupId = try row.get(Meetup.foreignIdKey)
    presenterId = try row.get("presenter_id")
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set("description", description)
    try row.set(User.foreignIdKey, userId)
    try row.set(Meetup.foreignIdKey, meetupId)
    try row.set("presenter_id", presenterId)
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
    try json.set("id", try assertExists())
    try json.set("description", description)
    try json.set("creatorId", userId)
    try json.set("votes", votesCount)
    try json.set("voter", voter)
    try json.set("presenterId", presenterId)
    try json.set("meetupId", meetupId)
    return json
  }
}

// MARK: Votes

extension Topic {
  var votes: Siblings<Topic, User, Pivot<Topic, User>> {
    return siblings()
  }
}
