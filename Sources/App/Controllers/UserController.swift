import Vapor
import HTTP

final class UserController {
  
  func register(_ req: Request) throws -> ResponseRepresentable {
    
    guard let json = req.json else {
      
      return try JSON(node: ["status": 400, "message": "no json provided"])
    }
    
    return json
  }
}
