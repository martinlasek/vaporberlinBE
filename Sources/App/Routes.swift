import Vapor
import AuthProvider

extension Droplet {
  
  func setupRoutes() throws {
      
    /* controller */
    let mc = MeetupController()
    let uc = UserController()
    let tc = TopicController()
    
    /* public routes */
    get("api/meetup/upcoming", handler: mc.upcomingMeetup)
    get("api/topic/list", handler: tc.listTopic)
    post("api/user", handler: uc.register)
    
    /* basic auth secured routes */
    let password = grouped([PasswordAuthenticationMiddleware(User.self)])
    password.post("api/login", handler: uc.login)
    
    /* token secured routes */
    let tokenMW = grouped([TokenAuthenticationMiddleware(User.self)])
    tokenMW.get("api/user", handler: uc.getUser)
    tokenMW.post("api/topic", handler: tc.createTopic)
    tokenMW.post("api/topic/vote", handler: tc.vote)
  }
}
