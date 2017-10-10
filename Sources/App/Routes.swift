import Vapor
import AuthProvider

extension Droplet {
  
  func setupRoutes() throws {
      
    /* controllers */
    let uc = UserController()
    let tc = TopicController()
    
    /* index (vuejs) */
    get("/") { req in
      return try self.view.make("index")
    }
    
    /* public routes */
    get("api/topic/list", handler: tc.listTopic)
    post("api/user", handler: uc.register)
    
    /* basic auth secured routes */
    let passwordMW = grouped([PasswordAuthenticationMiddleware(User.self)])
    passwordMW.post("api/login", handler: uc.login)
    
    /* token secured routes */
    let tokenMW = grouped([TokenAuthenticationMiddleware(User.self)])
    tokenMW.group("api") { routeBuilder in
        routeBuilder.get("user", handler: uc.getUser)
        routeBuilder.post("topic", handler: tc.createTopic)
        routeBuilder.post("topic/vote", handler: tc.vote)
        routeBuilder.post("logout", handler: uc.logout)
    }
  }
}
