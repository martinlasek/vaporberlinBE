final class Helper {
  
  static func validateEmail(_ email: String) -> Bool {
    /// email must at least look like a@b.cd
    let minLength = 6
    var valid = false
    valid = email.range(of: "@") != nil
    valid = email.count >= minLength
    return valid
  }
  
  static func validatePassword(_ password: String) -> Bool {
    let minLength = 8
    return password.count >= minLength
  }
  
  static func errorJson(status: Int, message: String) throws -> JSON {
    return try JSON(node: ["status": status, "message": message])
  }
}
