import Cocoa

struct ABC: Decodable {
    var date: Date?
}

var decoder = JSONDecoder()
//decoder.dateDecodingStrategy = .iso8601
decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)

    let container = try decoder.singleValueContainer()
    let dateStr = try container.decode(String.self)

    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    if let date = formatter.date(from: dateStr) {
        return date
    }
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    if let date = formatter.date(from: dateStr) {
        return date
    }
    return Date()
})

let json: [String: Any] = [
    "date": "2021-02-13T20:08:43.000+00:00"
]

let data = try! JSONSerialization.data(withJSONObject: json, options: [])
let abc = try! decoder.decode(ABC.self, from: data)
print(abc)
