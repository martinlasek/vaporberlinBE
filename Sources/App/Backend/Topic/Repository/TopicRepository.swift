class TopicRepository {
  
  func findAll() throws -> [Topic]? {
    return try Topic.all()
  }
  
  func save(_ topic: Topic) throws -> Topic? {
    try topic.save()
    return topic
  }
  
  func findBy(_ id: Int) throws -> Topic? {
    return try Topic.find(id)
  }
  
  func findBy(_ ids: [Int]) throws -> [Topic]? {
    return try Topic.makeQuery().filter("id", in: ids).all()
  }
}
