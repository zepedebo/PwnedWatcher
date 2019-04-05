import Foundation

struct PwndEntry: Codable {
    var Name, Title, Domain: String
    var BreachDate, AddedDate, ModifiedDate : String
    var PwnCount: Int
    var Description : String
    var LogoType : String?
    var LogoPath: String
    var DataClasses : [String]
    var IsVerified, IsFabricated, IsSensitive : Bool
    var IsRetired, IsSpamList : Bool
}
