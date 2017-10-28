struct CreateMeetupResponse: JSONRepresentable {
  let date: String
  let upcoming: Bool
  let title: String
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("date", date)
    try json.set("upcoming", upcoming)
    try json.set("title", title)
    return json
  }
  
  static func fromEntity(_ meetup: Meetup) -> CreateMeetupResponse {
    return CreateMeetupResponse(date: meetup.date, upcoming: meetup.upcoming, title: meetup.title)
  }
}
