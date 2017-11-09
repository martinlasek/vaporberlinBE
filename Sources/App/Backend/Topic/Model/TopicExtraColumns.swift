import FluentProvider

struct TopicExtraColumn: Preparation {
  static func prepare(_ database: Database) throws {
    try database.modify(Topic.self) { builder in
      builder.int(Meetup.foreignIdKey, optional: true, default: nil)
      builder.int("presenter_id", optional: true, default: nil)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(Topic.self)
  }
}
