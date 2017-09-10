import Vapor

extension Droplet {
  
  func setupRoutes() throws {
      
      /* meetup routes */
      let mc = MeetupController()
      get("meetup/upcoming", handler: mc.upcomingMeetup)
    
      /* user routes */
      let uc = UserController()
      post("user", handler: uc.register)
    }
}
