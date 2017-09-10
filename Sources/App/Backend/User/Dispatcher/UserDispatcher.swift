class UserDispatcher {
  lazy var userRepository = UserRepository()
  
  func checkEmailExists(_ req: EmailExistRequest) throws -> Bool {
    return try getByEmail(email: req.email) == nil
  }
  
  private func getByEmail(email: String) throws -> User? {
    return try userRepository.findByEmail(email: email)
  }
}
