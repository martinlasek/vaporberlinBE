import Vapor
import AuthProvider

extension Droplet {
  
  func setupRoutes() throws {
      
    /* meetup routes */
    let mc = MeetupController()
    get("meetup/upcoming", handler: mc.upcomingMeetup)
    
    /* user routes */
    let uc = UserController()
    post("api/user", handler: uc.register)
    
    /* basic auth secured routes */
    let password = grouped([PasswordAuthenticationMiddleware(User.self)])
    password.post("api/login", handler: uc.login)
    
    /* token secured routes */
    let tokenMW = grouped([TokenAuthenticationMiddleware(User.self)])
    tokenMW.get("api/user", handler: uc.user)
  }
}
