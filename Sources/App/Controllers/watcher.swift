import Vapor

final class WatcherController {
    func showList(_ req: Request) throws -> Future<View>  {
        return MonitoredEMail.query(on: req).all().flatMap { addresses in
            let accountList = addresses.map {address -> Future<AccountEntry> in
                let promise = req.eventLoop.newPromise(AccountEntry.self)
                DispatchQueue.global().async {
                    do {
                        let client = try req.make(Client.self)
                        let query = "https://haveibeenpwned.com/api/v2/breachedaccount/" + address.address
                        let response = client.get(query, headers: ["User-Agent":"account checker"])
                        
                        let pwndData = try response.flatMap(to: [PwndEntry].self) { response -> Future<[PwndEntry]> in
                            return try response.content.decode([PwndEntry].self)
                            }.wait()
                        promise.succeed(result: AccountEntry(Address: address.address, Pwnd: pwndData))
                    } catch {
                        promise.fail(error: error)
                    }
                }
                return promise.futureResult;
            }
            return try req.view().render("emaillist", ["addresses": accountList])
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
