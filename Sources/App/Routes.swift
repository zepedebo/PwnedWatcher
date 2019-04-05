import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let emailController = EmailController()
    router.get("emails", use:emailController.getEMails)
    router.post("emails", use:emailController.addEMail)
    
    let pwndController = PwndController()
    router.get("pwnd", use:pwndController.getPWND)
    router.post("pwnd", use:pwndController.addPWND)
}
