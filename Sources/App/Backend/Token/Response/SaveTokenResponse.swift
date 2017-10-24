struct SaveTokenResponse: JSONRepresentable {
  let token: Token
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("token", token.token)
    return json
  }
}
