import Vapor

extension Droplet {
  
  func setupRoutes() throws {
      get("hello") { req in
        var json = JSON()
        try json.set("hello", "world")
        return json
      }
      
      /* meetup routes */
      let mc = MeetupController()
      let uc = UserController()
      get("meetup/upcoming", handler: mc.upcomingMeetup)
      post("user", handler: uc.register)
    }
}
