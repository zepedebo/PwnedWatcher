import Vapor

final class EmailController {
    
    func getEMails(_ req: Request) throws -> Future<View> {
        let storedAddresses = MonitoredEMail.query(on: req).all()
        
        return storedAddresses.flatMap { addresses in
            let data = ["addresses": addresses]
            return try req.view().render("email", data)
        }
    }

    func addEMail(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(MonitoredEMail.self).flatMap { url in
            return url.save(on: req).map { _ in
                return req.redirect(to: "/emails")
            }
        }
    }
    
 
}
