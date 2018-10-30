import FluentSQLite
import Vapor

final class MonitoredURL: SQLiteModel {
    var id: Int?
    var url: String
    
    init(id: Int? = nil, url: String) {
        self.id = id;
        self.url = url;
    }
}

extension MonitoredURL: Content {}
extension MonitoredURL: Migration {}
