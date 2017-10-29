struct UpcomingMeetupResponse: JSONRepresentable {
  let date: String
  let upcoming: Bool
  let title: String
  let timeStart: String?
  let timeEnd: String?
  let link: String?
  
  static func fromEntity(_ meetup: Meetup) -> UpcomingMeetupResponse {
    return UpcomingMeetupResponse(
      date: meetup.date,
      upcoming: meetup.upcoming,
      title: meetup.title,
      timeStart: meetup.timeStart,
      timeEnd: meetup.timeEnd,
      link: meetup.link
    )
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("date", date)
    try json.set("upcoming", upcoming)
    try json.set("title", title)
    try json.set("timeStart", timeStart)
    try json.set("timeEnd", timeEnd)
    try json.set("link", link)
    return json
  }
}
