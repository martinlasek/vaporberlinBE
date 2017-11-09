import AuthProvider

final class MeetupController {
  let drop: Droplet
  let meetupDispatcher: MeetupDispatcher
  
  init(drop: Droplet) {
    self.drop = drop
    self.meetupDispatcher = MeetupDispatcher()
  }
  
  func setupRoutes() {
    
    /// public
    let api = drop.grouped("api")
    api.get("meetup", handler: list)
    api.get("meetup/upcoming", handler: getUpcomingMeetup)
    
    // token
    let apiTokenMW = api.grouped([TokenAuthenticationMiddleware(User.self)])
    apiTokenMW.post("meetup", handler: create)
    apiTokenMW.post("meetup/topics", handler: assignTopics)
  }
  
  /// create
  func create(_ req: Request) throws -> ResponseRepresentable {
    guard let json = req.json else {
      return try Helper.errorJson(status: 400, message: "no json provided")
    }
    
    var meetup: Meetup
    do { meetup = try Meetup(json: json) }
    catch { return try Helper.errorJson(status: 400, message: "could not create meetup with 'json: \(json)'") }
    
    let user = try req.auth.assertAuthenticated(User.self)
    if (!user.isAdmin) {
      return try Helper.errorJson(status: 401, message: "permission denied")
    }
    
    let req = CreateMeetupRequest(date: meetup.date, upcoming: meetup.upcoming, title: meetup.title)
    guard let res = try meetupDispatcher.create(req: req) else {
      return try Helper.errorJson(status: 500, message: "could not create meetup with 'json: \(json)'")
    }
    
    return try res.makeJSON()
  }
  
  /// list
  func list(_ req: Request) throws -> ResponseRepresentable {
    guard let res = try meetupDispatcher.getList(req: MeetupListRequest()) else {
      return try Helper.errorJson(status: 406, message: "could not get list of meetups")
    }
    
    return try res.makeJSON()
  }
  
  /// assign topics
  func assignTopics(_ req: Request) throws -> ResponseRepresentable {
    guard
      let json = req.json,
      let meetupId = json["meetup_id"]?.int
    else {
      return try Helper.errorJson(status: 400, message: "missing json or specific json data")
    }
    
    var topicIds: [Int]
    do { topicIds = try json.get("topic_ids") as [Int] }
    catch { return try Helper.errorJson(status: 400, message: "topic ids must be of type int in 'json: \(json)'") }
    
    let user = try req.auth.assertAuthenticated(User.self)
    if (!user.isAdmin) {
      return try Helper.errorJson(status: 401, message: "permission denied")
    }
    
    let req = AssignTopicsRequest(meetupId: meetupId, topicIds: topicIds)
    guard let res =  try meetupDispatcher.assignTopics(req: req) else {
      return try Helper.errorJson(status: 406, message: "could not assign meetup to topics with 'json: \(json)'")
    }
    
    return try res.makeJSON()
  }
  
  func getUpcomingMeetup(_ req: Request) throws -> ResponseRepresentable {
    guard let res = try meetupDispatcher.getUpcoming(req: UpcomingMeetupRequest()) else {
      return try Helper.errorJson(status: 404, message: "could not find an upcoming meetup")
    }
    
    return try res.makeJSON()
  }
}
