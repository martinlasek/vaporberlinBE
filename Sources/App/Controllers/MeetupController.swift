import Vapor
import HTTP

final class MeetupController {
  
  func upcomingMeetup(_ req: Request) throws -> ResponseRepresentable {
    return try JSON(node: ["Hey": "Listen"])
  }
}
