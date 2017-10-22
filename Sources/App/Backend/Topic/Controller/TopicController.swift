import AuthProvider

final class TopicController {
  let drop: Droplet
  let topicDispatcher: TopicDispatcher
  
  init(drop: Droplet) {
    self.drop = drop
    self.topicDispatcher = TopicDispatcher()
  }
  
  func setupRoutes() {
    
    /// public
    let api = drop.grouped("api")
    api.get("topic/list", handler: listTopic)
    
    /// token
    let apiTokenMW = api.grouped([TokenAuthenticationMiddleware(User.self)])
    apiTokenMW.post("topic", handler: createTopic)
    apiTokenMW.post("topic/vote", handler: vote)
  }
  
  // create topic
  func createTopic(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.auth.assertAuthenticated(User.self)
    guard let json = req.json else {
      return try JSON(node: ["status": 406, "message": "no json provided"])
    }
    let description = try json.get("description") as String
    let req = CreateTopicRequest(description: description, user: user)
    guard let resp = try topicDispatcher.create(req: req) else {
      return try JSON(node: ["status": 500, "message": "could not create topic with 'description: \(description)'"])
    }
    return try resp.makeJSON()
  }
  
  // list topics
  func listTopic(_ req: Request) throws -> ResponseRepresentable {
    guard let topicsResp = try topicDispatcher.getList(req: TopicListRequest()) else {
      return try JSON(node: ["status": 500, "message": "could not get list of topics"])
    }
    return try topicsResp.makeJSON()
  }
  
  /// vote a topic
  func vote(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.auth.assertAuthenticated(User.self)
    guard let json = req.json else {
      return try JSON(node: ["status": 406, "message": "no json provided"])
    }
    
    let topicId = try json.get("topicid") as Int
    let topicList = try user.votes.filter("id", topicId).all()
    
    if (topicList.count > 0) {
      return try JSON(node: ["status": 406, "message": "you cannot vote for already voted topics"])
    }
    
    guard let topic = try Topic.find(topicId) else {
      return try JSON(node: ["status": 406, "message": "could not find topic with id: \(topicId)"])
    }
    
    try topic.votes.add(user)
    return try JSON(node: ["status": 200, "message": "successfully voted"])
  }
}
