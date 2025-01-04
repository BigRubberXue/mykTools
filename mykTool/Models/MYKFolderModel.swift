// 文件模型
import Foundation

struct MYKFile: Identifiable, Codable, Equatable {
    var id: UUID
    var originalString: String
    var processedString: String
    var createDate: Date
    var keyName: String
    var title: String
    private(set) var indexNum: Int?
    var duration: Double?
    
    // 编码键
    enum CodingKeys: String, CodingKey {
        case id
        case originalString
        case processedString
        case createDate
        case keyName
        case title
        case indexNum
        case duration
    }
    
    // 编码
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(originalString, forKey: .originalString)
        try container.encode(processedString, forKey: .processedString)
        try container.encode(createDate, forKey: .createDate)
        try container.encode(keyName, forKey: .keyName)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(indexNum, forKey: .indexNum)
        try container.encodeIfPresent(duration, forKey: .duration)
    }
    
    // 解码
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        originalString = try container.decode(String.self, forKey: .originalString)
        processedString = try container.decode(String.self, forKey: .processedString)
        createDate = try container.decode(Date.self, forKey: .createDate)
        keyName = try container.decode(String.self, forKey: .keyName)
        title = try container.decode(String.self, forKey: .title)
        indexNum = try container.decodeIfPresent(Int.self, forKey: .indexNum)
        duration = try container.decodeIfPresent(Double.self, forKey: .duration)
    }
    
    // 常规初始化方法
    init(id: UUID = UUID(), 
         originalString: String, 
         processedString: String, 
         createDate: Date = Date(), 
         keyName: String,
         title: String = "",
         duration: Double? = 0) {
        self.id = id
        self.originalString = originalString
        self.processedString = processedString
        self.createDate = createDate
        self.keyName = keyName
        self.title = title
        self.duration = duration
    }
    
    // 添加修改 indexNum 的方法
    mutating func updateIndexNum(_ newIndex: Int?) {
        self.indexNum = newIndex
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.keyName == rhs.keyName
    }
}

// 文件夹模型
struct MYKMusicFolder: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var files: [MYKFile]
    var createDate: Date
    private(set) var indexNum: Int?
    
    // 编码键
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case files
        case createDate
    }
    
    // 编码
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(files, forKey: .files)
        try container.encode(createDate, forKey: .createDate)
    }
    
    // 解码
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        files = try container.decode([MYKFile].self, forKey: .files)
        createDate = try container.decode(Date.self, forKey: .createDate)
    }
    
    // 常规初始化方法
    init(id: UUID = UUID(), name: String, files: [MYKFile] = [], createDate: Date = Date()) {
        self.id = id
        self.name = name
        self.files = files
        self.createDate = createDate
    }
    
    // 添加更新索引的方法
    mutating func updateIndexNum(_ newIndex: Int?) {
        self.indexNum = newIndex
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
