class TokenDispatcher {
  var tokenRepository: TokenRepository
  
  init() {
    tokenRepository = TokenRepository()
  }
  
  func generate(req: SaveTokenRequest) throws -> SaveTokenResponse? {
    let token = try Token.generate(for: req.user)
    guard let t = try tokenRepository.save(token) else {
      return nil
    }
    return SaveTokenResponse(token: t)
  }
}
