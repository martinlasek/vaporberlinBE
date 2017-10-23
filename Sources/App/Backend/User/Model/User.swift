import Vapor
import FluentProvider
import AuthProvider

final class User: Model {
  let storage = Storage()
  var email: String
  var password: String
  var firstname: String?
  var lastname: String?
  var website: String?
  var company: String?
  
  init(
    email: String,
    password: String,
    firstname: String? = nil,
    lastname: String? = nil,
    website: String? = nil,
    company: String? = nil
  ) {
    self.email = email
    self.password = password
    self.firstname = firstname
    self.lastname = lastname
    self.website = website
    self.company = company
  }
  
  init(row: Row) throws {
    email = try row.get("email")
    password = try row.get("password")
    firstname = try row.get("firstname")
    lastname = try row.get("lastname")
    website = try row.get("website")
    company = try row.get("company")
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set("email", email)
    try row.set("password", password)
    try row.set("firstname", firstname)
    try row.set("lastname", lastname)
    try row.set("website", website)
    try row.set("company", company)
    return row
  }
}

// MARK: Preparation

extension User: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string("email")
      builder.string("password")
      builder.string("firstname", optional: true)
      builder.string("lastname", optional: true)
      builder.string("website", optional: true)
      builder.string("company", optional: true)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: JSON

extension User: JSONConvertible {
  convenience init(json: JSON) throws {
    try self.init(
      email: json.get("email"),
      password: json.get("password"),
      firstname: json.get("firstname"),
      lastname: json.get("lastname"),
      website: json.get("website"),
      company: json.get("company")
    )
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("id", id!.int)
    try json.set("email", email)
    try json.set("password", password)
    try json.set("firstname", firstname)
    try json.set("lastname", lastname)
    try json.set("website", website)
    try json.set("company", company)
    return json
  }
}

// MARK: Auth

extension User: PasswordAuthenticatable {
  public var hashedPassword: String? {
    return password
  }
  public static var passwordVerifier: PasswordVerifier? {
    return MyPasswordVerifier()
  }
}

struct MyPasswordVerifier: PasswordVerifier {
  func verify(password: Bytes, matches hash: Bytes) throws -> Bool {
    return try BCryptHasher().verify(password: password, matches: hash)
  }
}

// MARK: Token

extension User: TokenAuthenticatable {
  typealias TokenType = Token
}

// MARK: Topics

extension User {
  var topics: Children<User, Topic> {
    return children()
  }
}

// MARK: Votes

extension User {
  var votes: Siblings<User, Topic, Pivot<User, Topic>> {
    return siblings()
  }
}
