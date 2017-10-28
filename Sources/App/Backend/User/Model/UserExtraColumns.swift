import FluentProvider

struct UserExtraColumns: Preparation {
  static func prepare(_ database: Database) throws {
    try database.modify(User.self) { builder in
      builder.bool("is_admin", optional: true, default: nil)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(User.self)
  }
}
