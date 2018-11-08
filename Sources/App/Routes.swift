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
    
    router.get("helloView")  { req -> Future<View> in
        return try req.view().render("hello")
    }
    // Routes for the list of pwnd sites
    router.get("sites", use:listController.pwndList)
    
    // Routes for just the list of e-mails with no pwnd info
    router.get("simple", use: simpleController.showList)
    router.post("simple", use: simpleController.addEMail)
    
    // Routes for the full watcher
    router.post("emails", use: watcherController.addEMail) 
    router.get("emails", use:watcherController.showList) 
}
