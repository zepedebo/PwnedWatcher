import Vapor

struct AccountEntry: Codable {
    var Address: String;
    var Pwnd: [PwndEntry];
}

final class PwndController {
    func getPWND(_ req: Request) throws -> Future<View> {
        let storedAddresses = MonitoredEMail.query(on: req).all()
        
        return storedAddresses.flatMap { addresses in
            let accountList = try addresses.map {address -> Future<AccountEntry> in
                return try self.getAccountEntry(req: req, address: address.address)
            }            
            return try req.view().render("pwnd", ["addresses": accountList])
        }
    }
    
    func addPWND(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(MonitoredEMail.self).flatMap { url in
            return url.save(on: req).map { _ in
                return req.redirect(to: "/pwnd")
            }
        }
    }

    func decodePWNDResponse(response: Future<Response>) throws -> Future<[PwndEntry]> {
        let pwndData = response.flatMap(to: [PwndEntry].self) { entryResponse -> Future<[PwndEntry]> in
            guard entryResponse.http.status == HTTPResponseStatus.ok else {
                return response.map(to: [PwndEntry].self, {_ in return [PwndEntry]()});
            }
            return try entryResponse.content.decode([PwndEntry].self)
        }
        return pwndData
    }
    
    func callPWNDService(req: Request, address: String) throws -> Future<[PwndEntry]> {
        let client = try req.make(Client.self)
        let query = "https://haveibeenpwned.com/api/v2/breachedaccount/" + address
        let response = client.get(query, headers: ["User-Agent":"account checker"])
        
        return try decodePWNDResponse(response: response)
    }
    
    func getAccountEntry(req: Request, address: String) throws -> Future<AccountEntry> {
        let promise = req.eventLoop.newPromise(AccountEntry.self)
        DispatchQueue.global().async {
            do {
                // Make the call
                let pwndData = try self.callPWNDService(req: req, address: address).wait()
                promise.succeed(result: AccountEntry(Address: address, Pwnd: pwndData))
            } catch {
                promise.fail(error: error)
            }
        }
        return promise.futureResult;
    }
}
