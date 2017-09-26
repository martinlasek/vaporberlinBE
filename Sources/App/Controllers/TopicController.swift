import Vapor

final class TopicController {
  
  lazy var topicDispatcher = TopicDispatcher()
  
  /** TODO: pass data to dispatcher (createTopic) and number crunch over there */
  func createTopic(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.auth.assertAuthenticated(User.self)
    guard let json = req.json else {
      throw Abort(.badRequest, reason: "no json provided")
    }
    
    let topic = Topic(description: try json.get("description"), user: user)
    try topic.save()
    return try topic.makeJSON()
  }
  
  /** TOOD: pass request-topic-list to dispatch */
  func listTopic(_ req: Request) throws -> ResponseRepresentable {
    let topics = try Topic.all()
    let json = try JSON(node: ["topics": try topics.makeJSON()])
    return json
  }
}
