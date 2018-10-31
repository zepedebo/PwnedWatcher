import Vapor



//"Name":"000webhost",
//"Title":"000webhost",
//"Domain":"000webhost.com",
//"BreachDate":"2015-03-01",
//"AddedDate":"2015-10-26T23:35:45Z",
//"ModifiedDate":"2017-12-10T21:44:27Z",
//"PwnCount":14936670,
//"Description":"In approximately March 2015, the free web hosting provider <a href=\"http://www.troyhunt.com/2015/10/breaches-traders-plain-text-passwords.html\" target=\"_blank\" rel=\"noopener\">000webhost suffered a major data breach</a> that exposed almost 15 million customer records. The data was sold and traded before 000webhost was alerted in October. The breach included names, email addresses and plain text passwords.",
//"LogoType":"png",
//"DataClasses":["Email addresses","IP addresses","Names","Passwords"],
//"IsVerified":true,
//"IsFabricated":false,
//"IsSensitive":false,
//"IsRetired":false,
//"IsSpamList":false}

struct PwndEntry: Codable {
    var Name: String
    var Title: String
    var Domain: String
    var BreachDate : String
    var AddedDate : String
    var ModifiedDate : String
    var PwnCount : Int
    var Description : String
    var LogoType : String
    var DataClasses : [String]
    var IsVerified : Bool
    var IsFabricated : Bool
    var IsSensitive : Bool
    var IsRetired : Bool
    var IsSpamList : Bool
}

struct AccountEntry: Codable {
    var Address: String;
    var Pwnd: [PwndEntry];
//    var Cool: Bool
}


/// Register your application's routes here.
public func routes(_ router: Router) throws {
//        return MonitoredEMail.query(on: req).all().flatMap { urls in
//            let data =  try urls.flatMap { account -> Future<[AccountEntry]>  in
//                let client = try req.make(Client.self)
//                let response = client.get("https://haveibeenpwned.com/api/v2//breachedaccount/" + account.address, headers: ["User-Agent":"account checker"])
//                let pwndData = response.map(to: [PwndEntry].self) { response -> [PwndEntry] in
//                    return try response.content.decode([PwndEntry].self)
//                }
//                return AccountEntry(Address: account, Pwnd: pwndData)
//            }
//            return try req.view().render("emaillist", ["emaillist": data])
//        }
    router.get() { req -> Future<View> in
        return MonitoredEMail.query(on: req).all().flatMap { addresses in
            let q = addresses.map {address -> Future<AccountEntry> in
                let p = req.eventLoop.newPromise(AccountEntry.self)
                DispatchQueue.global().async {
                    do {
                        let client = try req.make(Client.self)
                        let query = "https://haveibeenpwned.com/api/v2/breachedaccount/" + address.address
                        let response = client.get(query, headers: ["User-Agent":"account checker"])
                        
                        let pwndData = try response.flatMap(to: [PwndEntry].self) { response -> Future<[PwndEntry]> in
                            return try response.content.decode([PwndEntry].self)
                        }.wait()
                        p.succeed(result: AccountEntry(Address: address.address, Pwnd: pwndData))
                    } catch {
                        p.fail(error: error)
                    }
                }
                return p.futureResult;
            }
            return try req.view().render("emaillist", ["addresses": q])
        }

    }
    
    router.get("sites") {req -> Future<View> in
        let client = try req.make(Client.self)    
//        let response = client.get("https://haveibeenpwned.com/api/v2/breaches", headers: ["User-Agent":"account checker"])
        let response = client.get("https://haveibeenpwned.com/api/v2/breachedaccount/test@example.com", headers: ["User-Agent":"account checker"])
        let exampleData = response.flatMap(to: [PwndEntry].self) { response in
            return try response.content.decode([PwndEntry].self)
        }
        let m = String(reflecting: exampleData)
        return try req.view().render("pwnd", ["pwndlist" : exampleData])


    }
    
    router.post("urls") {req -> Future<Response> in
        return try req.content.decode(MonitoredEMail.self).flatMap { url in
            return url.save(on: req).map { _ in
                return req.redirect(to: "/")
            }
        }
    }
}
