class TokenRepository {
 
  func save(_ token: Token) throws -> Token? {
    try token.save()
    return token
  }
}
