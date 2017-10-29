struct MeetupListResponse: JSONRepresentable {
  let list: [Meetup]
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("list", try list.makeJSON())
    return json
  }
}
