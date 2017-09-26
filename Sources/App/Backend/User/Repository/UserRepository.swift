class UserRepository {
 
  func findByEmail(email: String) throws -> User? {
    return try User.makeQuery().filter("email", email).first()
  }
}
