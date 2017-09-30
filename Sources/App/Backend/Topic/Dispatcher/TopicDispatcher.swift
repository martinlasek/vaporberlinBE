class TopicDispatcher {
  lazy var topicRepository = TopicRepository()
  
  func getList(req: TopicListRequest) throws -> TopicListResponse? {
    let list = try topicRepository.getList()
    return TopicListResponse(list: list)
  }
}
