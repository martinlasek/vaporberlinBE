struct CreateTopicResponse: JSONRepresentable {
  let id: Int
  let description: String
  let userId: Int
  
  static func fromEntity(topic: Topic) -> CreateTopicResponse {
    return CreateTopicResponse(id: topic.id!.int!, description: topic.description, userId: topic.userId)
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("id", id)
    try json.set("description", description)
    try json.set("userId", userId)
    return json
  }
}
