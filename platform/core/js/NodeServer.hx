package platform.core.js;

import sys.Http;
import js.node.Http;

class NodeServer {
    public static function main() {
        Http.createServer(function(req, res) {
            if (req.method == "POST" && req.url == "/api/chat") {
                var body = "";
                req.on("data", chunk -> body += chunk);
                req.on("end", () -> {
                    // Forward the request to the C++ gateway on port 9090
                    var gatewayReq = new sys.Http("http://localhost:9090/llm/request");
                    gatewayReq.setHeader("Content-Type", "application/json");
                    gatewayReq.setPostData(body);
                    gatewayReq.onData = (data) -> {
                        res.setHeader("Content-Type", "application/json");
                        res.end(data);
                    };
                    gatewayReq.onError = (error) -> {
                        res.statusCode = 500;
                        res.end('{"error": "Gateway communication failed"}');
                    };
                    gatewayReq.request(true);
                });
            } else {
                // Basic static file serving for the React app would go here
                res.statusCode = 404;
                res.end("Not Found");
            }
        }).listen(8080, () -> trace('Node.js server running on http://localhost:8080'));
    }
}