import Vapor

final class TopicController {
  
  lazy var topicDispatcher = TopicDispatcher()
  
  func createTopic(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.auth.assertAuthenticated(User.self)
    guard let json = req.json else {
      throw Abort(.badRequest, reason: "no json provided")
    }
    
    let topic = Topic(description: try json.get("description"), user: user)
    
    try topic.save()
    return try topic.makeJSON()
  }
}
