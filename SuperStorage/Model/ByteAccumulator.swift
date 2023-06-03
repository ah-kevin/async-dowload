
///
import Foundation

// 一个累积接收到的数据到字节数组的类型。
struct ByteAccumulator: CustomStringConvertible {
  private var offset = 0 // 偏移量
  private var counter = -1 // 计数器
  private let name: String // 名称
  private let size: Int // 大小
  private let chunkCount: Int // 块数量
  private var bytes: [UInt8] // 字节数组
  var data: Data { return Data(bytes[0 ..< offset]) } // 数据

  // 创建一个命名的字节累加器。
  init(name: String, size: Int) {
    self.name = name
    self.size = size
    chunkCount = max(Int(Double(size) / 20), 1)
    bytes = [UInt8](repeating: 0, count: size)
  }

  // 将字节追加到累加器。
  mutating func append(_ byte: UInt8) {
    bytes[offset] = byte
    counter += 1
    offset += 1
  }

  // 如果当前批次已填充字节，则为 true。
  var isBatchCompleted: Bool {
    return counter >= chunkCount
  }

  // 检查是否完成。
  mutating func checkCompleted() -> Bool {
    defer { counter = 0 }
    return counter == 0
  }

  // 总体进度。
  var progress: Double {
    Double(offset) / Double(size)
  }

  // 描述
  var description: String {
    "[\(name)] \(sizeFormatter.string(fromByteCount: Int64(offset)))"
  }
}
