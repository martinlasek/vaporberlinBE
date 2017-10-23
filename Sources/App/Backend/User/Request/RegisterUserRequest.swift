struct RegisterUserRequest {
  let email: String
  let password: String
  
  static func fromJSON(_ json: JSON) throws -> RegisterUserRequest {
    return try RegisterUserRequest(
      email: json.get("email"),
      password: json.get("password")
    )
  }
}
