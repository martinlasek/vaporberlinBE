import AuthProvider

final class MeetupController {
  let drop: Droplet
  let meetupDispatcher: MeetupDispatcher
  
  init(drop: Droplet) {
    self.drop = drop
    self.meetupDispatcher = MeetupDispatcher()
  }
  
  func setupRoutes() {
    let api = drop.grouped("api")
    let apiTokenMW = api.grouped([TokenAuthenticationMiddleware(User.self)])
    apiTokenMW.post("meetup", handler: create)
  }
  
  func create(_ req: Request) throws -> ResponseRepresentable {
    guard let json = req.json else {
      return try Helper.errorJson(status: 406, message: "no json provided")
    }
    
    var meetup: Meetup
    do { meetup = try Meetup(json: json) }
    catch { return try Helper.errorJson(status: 406, message: "could not create meetup with 'json: \(json)'") }
    
    let user = try req.auth.assertAuthenticated(User.self)
    if (!user.isAdmin) {
      return try Helper.errorJson(status: 401, message: "permission denied")
    }
    
    let req = CreateMeetupRequest(date: meetup.date, upcoming: meetup.upcoming, title: meetup.title)
    guard let res = try meetupDispatcher.create(req: req) else {
      return try Helper.errorJson(status: 406, message: "could not create meetup with 'json: \(json)'")
    }
    
    return try res.makeJSON()
  }
}
