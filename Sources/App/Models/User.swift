import Vapor
import FluentProvider

final class User: Model {
  
  let storage = Storage()
  var email: String
  var password: String
  var firstname: String?
  var lastname: String?
  var website: String?
  var company: String?
  var companyWebsite: String?
  
  init(
    email: String,
    password: String,
    firstname: String?,
    lastname: String?,
    website: String?,
    company: String?,
    companyWebsite: String?
  ) {
    
    self.email = email
    self.password = password
    self.firstname = firstname
    self.lastname = lastname
    self.website = website
    self.company = company
    self.companyWebsite = companyWebsite
  }
  
  init(row: Row) throws {
    
    email = try row.get("email")
    password = try row.get("password")
    firstname = try row.get("firstname")
    lastname = try row.get("lastname")
    website = try row.get("website")
    company = try row.get("company")
    companyWebsite = try row.get("company_website")
  }
  
  func makeRow() throws -> Row {
    
    var row = Row()
    try row.set("email", email)
    try row.set("password", password)
    try row.set("firstname", firstname)
    try row.set("lastname", lastname)
    try row.set("website", website)
    try row.set("company", company)
    try row.set("company_website", companyWebsite)
    return row
  }
}

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
      builder.string("company_website", optional: true)
    }
  }
  
  static func revert(_ database: Database) throws {
    
    try database.delete(self)
  }
}
