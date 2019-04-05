import FluentSQLite
import Vapor

final class MonitoredEMail: SQLiteModel {
    var id: Int?
    var address: String
    
    init(id: Int? = nil, address: String) {
        self.id = id
        self.address = address
    }
}

extension MonitoredEMail: Content {}
extension MonitoredEMail: Migration {}
