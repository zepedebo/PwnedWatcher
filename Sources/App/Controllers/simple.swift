import Vapor

final class SimpleController {
    
    func showList(_ req: Request) throws -> Future<View>  {
        return MonitoredEMail.query(on: req).all().flatMap { addresses  in
                let emaillist = addresses.map{ address -> String in
                return address.address
            }
            return try req.view().render("simple", ["addresses": emaillist])
        }
    }

    func addEMail(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(MonitoredEMail.self).flatMap { url in
            return url.save(on: req).map { _ in
                return req.redirect(to: "/simple")
            }
        }
    }
}

