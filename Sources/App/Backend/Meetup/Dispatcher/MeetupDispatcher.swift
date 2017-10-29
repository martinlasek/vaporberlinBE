final class MeetupDispatcher {
  let meetupRepository: MeetupRepository
  let topicRepository: TopicRepository
  
  init() {
    self.meetupRepository = MeetupRepository()
    self.topicRepository = TopicRepository()
  }
  
  func create(req: CreateMeetupRequest) throws -> CreateMeetupResponse? {
    let meetup = Meetup(date: req.date, upcoming: req.upcoming, title: req.title)
    guard let m = try meetupRepository.save(meetup) else {
      return nil
    }
    return CreateMeetupResponse.fromEntity(m)
  }
  
  func assignTopics(req: AssignTopicsRequest) throws -> AssignTopicsResponse? {
    guard let topics = try topicRepository.findBy(req.topicIds) else {
      return nil
    }
    
    for topic in topics {
      topic.meetupId = req.meetupId
      try topic.save()
    }
    
    return AssignTopicsResponse(topics: topics)
  }
  
  func getList(req: MeetupListRequest) throws -> MeetupListResponse? {
    guard let meetups = try meetupRepository.findAll() else {
      return nil
    }
    
    return MeetupListResponse(list: meetups)
  }
  
  func getUpcoming(req: UpcomingMeetupRequest) throws -> UpcomingMeetupResponse? {
    guard let upcomingMeetup = try meetupRepository.findUpcoming() else {
      return nil
    }
    
    return UpcomingMeetupResponse.fromEntity(upcomingMeetup)
  }
}
