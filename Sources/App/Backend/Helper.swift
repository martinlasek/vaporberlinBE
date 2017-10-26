final class Helper {
  
  static func validateEmail(_ email: String) -> Bool {
    /// email must at least have 6 characters e.g: a@b.cd
    let minLength = 6
    if
      email.range(of: "@") == nil ||
      email.range(of: ".") == nil ||
      email.characters.count < minLength
    {
      return false
    }
    
    return true
  }
  
  static func validatePassword(_ password: String) -> Bool {
    let minLength = 8
    return password.characters.count >= minLength
  }
  
  static func errorJson(status: Int, message: String) throws -> JSON {
    return try JSON(node: ["status": status, "message": message])
  }
}
