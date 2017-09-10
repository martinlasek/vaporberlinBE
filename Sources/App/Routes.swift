import Vapor
import AuthProvider

extension Droplet {
  
  func setupRoutes() throws {
      
    /* meetup routes */
    let mc = MeetupController()
    get("meetup/upcoming", handler: mc.upcomingMeetup)
    
    /* user routes */
    let uc = UserController()
    post("user", handler: uc.register)
    
    /* basic auth secured routes */
    let password = grouped([PasswordAuthenticationMiddleware(User.self)])
    password.post("login", handler: uc.login)
  }
}
