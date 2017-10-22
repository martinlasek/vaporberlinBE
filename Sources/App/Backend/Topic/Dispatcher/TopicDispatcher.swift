class TopicDispatcher {
  let topicRepository: TopicRepository
  
  init() {
    self.topicRepository = TopicRepository()
  }
  
  func getList(req: TopicListRequest) throws -> TopicListResponse? {
    let list = try topicRepository.findAll()
    return TopicListResponse(list: list)
  }
  
  func create(req: CreateTopicRequest) throws -> CreateTopicResponse? {
    let userId = req.user.id!.int!
    let topic = try topicRepository.save(Topic(description: req.description, userId: userId))
    try topic.votes.add(req.user)
    return CreateTopicResponse.fromEntity(topic: topic)
  }
}
