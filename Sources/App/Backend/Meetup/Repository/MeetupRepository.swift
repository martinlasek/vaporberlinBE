final class MeetupRepository {
  
  func save(_ meetup: Meetup) throws -> Meetup? {
    try meetup.save()
    return meetup
  }
  
  func findAll() throws -> [Meetup]? {
    return try Meetup.all()
  }
}
