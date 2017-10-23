struct RegisterUserResponse: JSONRepresentable {
  let email: String
  let firstname: String?
  let lastname: String?
  let website: String?
  let company: String?
  
  static func fromEntity(_ user: User) -> RegisterUserResponse {
    return RegisterUserResponse(
      email: user.email,
      firstname: user.firstname,
      lastname: user.lastname,
      website: user.website,
      company: user.company
    )
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("email", email)
    try json.set("firstname", firstname)
    try json.set("lastname", lastname)
    try json.set("website", website)
    try json.set("company", company)
    return json
  }
}
