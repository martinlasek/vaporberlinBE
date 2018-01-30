import Vapor
import AuthProvider

extension Droplet {
  func setupRoutes() throws {
      
    /// controllers
    let uc = UserController(drop: self)
    let tc = TopicController(drop: self)
    let mc = MeetupController(drop: self)
    uc.setupRoutes()
    tc.setupRoutes()
    mc.setupRoutes()
    
    /// index (vuejs)
    get("/") { req in
      return try self.view.make("index.html")
    }
  }
}
