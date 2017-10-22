class TopicRepository {
  
  func findAll() throws -> [Topic] {
    return try Topic.all()
  }
  
  func save(_ topic: Topic) throws -> Topic {
    try topic.save()
    return topic
  }
}
