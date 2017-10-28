final class MeetupDispatcher {
  let meetupRepository: MeetupRepository
  
  init() {
    self.meetupRepository = MeetupRepository()
  }
  
  func create(req: CreateMeetupRequest) throws -> CreateMeetupResponse? {
    var meetup = Meetup(date: req.date, upcoming: req.upcoming, title: req.title)
    meetup = try meetupRepository.save(meetup)
    return CreateMeetupResponse.fromEntity(meetup)
  }
}
