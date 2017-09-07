import Vapor
import FluentProvider

final class Meetup: Model {
  
  let storage = Storage()
  var date: Date
  var upcoming: Bool
  var title: String
  
  init(date: Date, upcoming: Bool, title: String) {
    
    self.date = date
    self.upcoming = upcoming
    self.title = title
  }
  
  init(row: Row) throws {
    
    date = try row.get("date")
    upcoming = try row.get("upcoming")
    title = try row.get("title")
  }
  
  func makeRow() throws -> Row {
    
    var row = Row()
    try row.set("date", date)
    try row.set("upcoming", upcoming)
    try row.set("title", title)
    return row
  }
}

extension Meetup: Preparation {
  
  static func prepare(_ database: Database) throws {
    
    try database.create(self) { builder in
      
      builder.id()
      builder.string("date")
      builder.bool("upcoming")
      builder.string("title")
    }
  }
  
  static func revert(_ database: Database) throws {
    
    try database.delete(self)
  }
}

// MARK: JSON

/// How the model converts from / to JSON
/// - creating a new Meetup (POST /meetup)
/// - fetching a new Meetip (GET /meetup, GET /meetup/:id)
extension Meetup: JSONConvertible {
  
  convenience init(json: JSON) throws {
    
    try self.init(
      date: json.get("date"),
      upcoming: json.get("upcoming"),
      title: json.get("title")
    )
  }
  
  func makeJSON() throws -> JSON {
    
    var json = JSON()
    try json.set("date", date)
    try json.set("upcoming", upcoming)
    try json.set("title", title)
    return json
  }
}
