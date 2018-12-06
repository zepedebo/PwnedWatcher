import Foundation

struct PwndEntry: Codable {
    var Name: String
    var Title: String
    var Domain: String
    var BreachDate : String
    var AddedDate : String
    var ModifiedDate : String
    var PwnCount : Int
    var Description : String
    var LogoType : String?
    var LogoPath: String
    var DataClasses : [String]
    var IsVerified : Bool
    var IsFabricated : Bool
    var IsSensitive : Bool
    var IsRetired : Bool
    var IsSpamList : Bool
}
