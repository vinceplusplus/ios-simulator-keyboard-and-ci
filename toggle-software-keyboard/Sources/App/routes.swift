import Vapor

// https://stackoverflow.com/a/50035059
func safeShell(_ command: String) throws -> String {
  let task = Process()
  let pipe = Pipe()
  
  task.standardOutput = pipe
  task.standardError = pipe
  task.arguments = ["-c", command]
  task.executableURL = URL(fileURLWithPath: "/bin/zsh")
  
  try task.run()
  
  let data = pipe.fileHandleForReading.readDataToEndOfFile()
  let output = String(data: data, encoding: .utf8)!
  
  return output
}

func routes(_ app: Application) throws {
  app.get { req in
    return "catch all handler"
  }
  
  app.get("toggle-software-keyboard") { req -> String in
    let path = Bundle.module.path(forResource: "toggle-software-keyboard.sh", ofType: nil)!
    return (try? safeShell("\(path)")) ?? ""
  }
}
