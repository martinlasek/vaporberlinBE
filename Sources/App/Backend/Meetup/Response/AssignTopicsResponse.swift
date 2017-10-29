struct AssignTopicsResponse: JSONRepresentable {
  let topics: [Topic]
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("topics", try topics.makeJSON())
    return json
  }
}
