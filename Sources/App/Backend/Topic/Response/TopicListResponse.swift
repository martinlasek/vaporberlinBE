class TopicListResponse {
  let list: [Topic]
  
  init(list: [Topic]) {
    self.list = list
  }
}

extension TopicListResponse: JSONRepresentable {
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("topics", try list.makeJSON())
    return json
  }
}
