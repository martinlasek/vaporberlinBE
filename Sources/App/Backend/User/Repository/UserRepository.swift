class UserRepository {
 
  func findByEmail(email: String) throws -> User? {
    return try User.makeQuery().filter("email", email).first()
  }
  
  func create(_ user: User) throws -> User? {
    try user.save()
    return user
  }
  
  func findAllBy(_ ids: [Int]) throws -> [User]? {
    return try User.makeQuery().filter("id", in: ids).all()
  }
}
