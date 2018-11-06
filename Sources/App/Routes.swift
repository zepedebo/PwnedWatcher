import Vapor


struct AccountEntry: Codable {
    var Address: String;
    var Pwnd: [PwndEntry];
}


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let listController = ListController()
    let watcherController = WatcherController()
    let simpleController = SimpleController()
    
    router.get("hello") { req in
        return "Hello"
    }
    
    
    
    router.get("sites", use:listController.pwndList)
    
    router.get("simple", use: simpleController.showList)
    router.post("simple", use: simpleController.addEMail)

    
    
    router.post("emails", use: watcherController.addEMail) 
    router.get("emails", use:watcherController.showList) 
}
