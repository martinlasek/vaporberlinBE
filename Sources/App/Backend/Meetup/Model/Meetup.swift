import Vapor
import FluentProvider

final class Meetup: Model {
  let storage = Storage()
  var date: String
  var upcoming: Bool
  var title: String
  var timeStart: String?
  var timeEnd: String?
  var link: String?
  
  init(date: String, upcoming: Bool, title: String, timeStart: String? = nil, timeEnd: String? = nil, link: String? = nil) {
    self.date = date
    self.upcoming = upcoming
    self.title = title
    self.timeStart = timeStart
    self.timeEnd = timeEnd
    self.link = link
  }
  
  init(row: Row) throws {
    date = try row.get("date")
    upcoming = try row.get("upcoming")
    title = try row.get("title")
    timeStart = try row.get("timestart")
    timeEnd = try row.get("timeend")
    link = try row.get("link")
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set("date", date)
    try row.set("upcoming", upcoming)
    try row.set("title", title)
    try row.set("timestart", timeStart)
    try row.set("timeend", timeEnd)
    try row.set("link", link)
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

extension Meetup: JSONConvertible {
  convenience init(json: JSON) throws {
    try self.init(
      date: json.get("date"),
      upcoming: json.get("upcoming"),
      title: json.get("title"),
      timeStart: json.get("timeStart"),
      timeEnd: json.get("timeEnd"),
      link: json.get("link")
    )
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("date", date)
    try json.set("upcoming", upcoming)
    try json.set("title", title)
    try json.set("timeStart", timeStart)
    try json.set("timeEnd", timeEnd)
    try json.set("link", link)
    return json
  }
}
