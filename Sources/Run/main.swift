import App
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }


app.http.server.configuration.hostname = "178.18.250.90"
app.http.server.configuration.port = 8080


try configure(app)
try app.run()
