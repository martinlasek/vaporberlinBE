class UserDispatcher {
  let userRepository: UserRepository
  
  init() {
    userRepository = UserRepository()
  }
  
  func register(req: RegisterUserRequest) throws -> RegisterUserResponse? {
    let user = User(email: req.email, password: req.password)
    user.password = try BCryptHasher().make(user.password.bytes).makeString()
    guard let usr = try userRepository.create(user) else {
      return nil
    }
    
    return RegisterUserResponse.fromEntity(usr)
  }
  
  func checkEmailExists(_ req: EmailExistRequest) throws -> Bool {
    return try getByEmail(email: req.email) != nil
  }
  
  private func getByEmail(email: String) throws -> User? {
    return try userRepository.findByEmail(email: email)
  }
}
