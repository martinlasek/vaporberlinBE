import FluentProvider

struct MeetupExtraColumns: Preparation {
  static func prepare(_ database: Database) throws {
    try database.modify(Meetup.self) { builder in
      builder.string("timestart", optional: true, default: nil)
      builder.string("timeend", optional: true, default: nil)
      builder.string("link", optional: true, default: nil)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(Meetup.self)
  }
}
