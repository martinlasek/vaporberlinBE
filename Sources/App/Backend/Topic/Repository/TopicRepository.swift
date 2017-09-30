class TopicRepository {
  
  func getList() throws -> [Topic]{
    return try Topic.all()
  }
}
