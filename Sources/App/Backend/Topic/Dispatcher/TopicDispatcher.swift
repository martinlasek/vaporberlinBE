class TopicDispatcher {
  let topicRepository: TopicRepository
  
  init() {
    self.topicRepository = TopicRepository()
  }
  
  func getList(req: TopicListRequest) throws -> TopicListResponse? {
    guard let list = try topicRepository.findAll() else {
      return nil
    }
    return TopicListResponse(list: list)
  }
  
  func create(req: CreateTopicRequest) throws -> CreateTopicResponse? {
    let userId = req.user.id!.int!
    guard let topic = try topicRepository.save(Topic(description: req.description, userId: userId)) else {
      return nil
    }
    try topic.votes.add(req.user)
    return CreateTopicResponse.fromEntity(topic: topic)
  }
  
  func vote(req: VoteTopicRequest) throws -> VoteTopicResponse? {
    let topicList = try req.user.votes.filter("id", req.topicId).all()
    if (topicList.count > 0) {
      return nil
    }
    guard let topic = try getById(topicId: req.topicId) else {
      return nil
    }
    try topic.votes.add(req.user)
    return VoteTopicResponse(topic: topic)
  }
  
  private func getById(topicId: Int) throws -> Topic? {
    return try topicRepository.findBy(topicId)
  }
}
