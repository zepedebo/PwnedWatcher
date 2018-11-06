import Vapor

final class ListController {
    func pwndList(_ req: Request) throws -> Future<View>  {
        let client = try req.make(Client.self)
        let response = client.get("https://haveibeenpwned.com/api/v2/breaches", headers: ["User-Agent":"account checker"])
        let exampleData = response.flatMap(to: [PwndEntry].self) { response in
            return try response.content.decode([PwndEntry].self)
        }
        return try req.view().render("sites", ["pwndlist" : exampleData])

    }
}
