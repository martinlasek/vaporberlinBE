class UserDispatcher {
  
  lazy var userRepository = UserRepository()
  
  func checkEmailExists(_ req: EmailExistRequest) throws -> Bool {
  
    if try getByEmail(email: req.email) == nil {
      
      return false
    }
    
    return true
  }
  
  private func getByEmail(email: String) throws -> User? {
    
    return try userRepository.findByEmail(email: email)
  }
}
