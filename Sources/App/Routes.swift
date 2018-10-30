import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("urls") { req -> Future<View> in
        return MonitoredURL.query(on: req).all().flatMap { urls in
            let data = ["urllist": urls]
            return try req.view().render("urllist", data)
        }
    }
    
    router.post("urls") {req -> Future<Response> in
        return try req.content.decode(MonitoredURL.self).flatMap { url in
            return url.save(on: req).map { _ in
                return req.redirect(to: "urls")
            }
            
        }
        
    }
}
