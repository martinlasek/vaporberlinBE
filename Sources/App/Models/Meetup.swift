import Vapor
import FluentProvider

final class Meetup: Model {
  
  let storage = Storage()
  var date: Date
  var active: Bool
  var title: String
  
  init(date: Date, active: Bool, title: String) {
    
    self.date = date
    self.active = active
    self.title = title
  }
  
  init(row: Row) throws {
    
    date = try row.get("date")
    active = try row.get("active")
    title = try row.get("title")
  }
  
  func makeRow() throws -> Row {
    
    var row = Row()
    try row.set("date", date)
    try row.set("active", active)
    try row.set("title", title)
    return row
  }
}

extension Meetup: Preparation {
  
  static func prepare(_ database: Database) throws {
    
    try database.create(self) { builder in
      
      builder.id()
      builder.string("date")
      builder.bool("active")
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
      active: json.get("active"),
      title: json.get("title")
    )
  }
  
  func makeJSON() throws -> JSON {
    
    var json = JSON()
    try json.set("date", date)
    try json.set("active", active)
    try json.set("title", title)
    return json
  }
}
