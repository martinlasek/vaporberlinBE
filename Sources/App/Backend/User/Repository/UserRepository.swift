class UserRepository {
 
  func findByEmail(email: String) throws -> User? {
    return try User.makeQuery().filter("email", email).first()
  }
  
  func create(_ user: User) throws -> User? {
    try user.save()
    return user
  }
}
