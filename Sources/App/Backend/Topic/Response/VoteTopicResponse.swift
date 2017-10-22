struct VoteTopicResponse: JSONRepresentable {
  let topic: Topic
  
  func makeJSON() throws -> JSON {
    return try topic.makeJSON()
  }
}
