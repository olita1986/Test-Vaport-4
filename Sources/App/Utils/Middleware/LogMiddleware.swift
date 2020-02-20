import Vapor

struct LogMiddleware: Middleware {
    
    let logger: Logger
    
    init(logger: Logger = Logger(label: "ola")) {
        self.logger = logger
    }
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
//        logger.info(Logger.Message(stringLiteral: request.description))
        let startDate = Date()
        return next.respond(to: request).map { response in
            self.log(response, start: startDate, for: request)
            return response
        }
    }
    
    func log(_ res: Response, start: Date, for req: Request) {
        let reqInfo = "\(req.method) \(req.url.path)"
        let resInfo = "\(res.status.code) " +
        "\(res.status.reasonPhrase)"
        let time = Date()
            .timeIntervalSince(start)
            .readableMilliseconds
        logger.info("\(reqInfo) -> \(resInfo) [\(time)]")
    }
}

extension TimeInterval {
  /// Converts the time internal to readable milliseconds format, i.e., "3.4ms"
  var readableMilliseconds: String {
    let string = (self * 1000).description
    // include one decimal point after the zero
    let endIndex = string.index(string.index(of: ".")!, offsetBy: 2)
    let trimmed = string[string.startIndex..<endIndex]
    return .init(trimmed) + "ms"
  }
}
