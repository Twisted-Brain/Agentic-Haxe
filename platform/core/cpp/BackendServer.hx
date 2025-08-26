package platform.core.cpp;

import sys.net.Socket;
import sys.net.Host;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import haxe.Json;
import haxe.io.Bytes;
import haxe.ds.StringMap;
import StringTools;

class BackendServer {
    private static var port:Int = 8080;

    public static function main() {
        var server = new SimpleHttpServer(port);
        trace('C++ Backend Server starting on http://localhost:$port');
        server.listen();
    }
}

class SimpleHttpServer {
    private var port:Int;
    private var wwwRoot:String = "www";

    public function new(port:Int) {
        this.port = port;
    }

    public function listen() {
        var socket = new Socket();
        socket.bind(new Host("0.0.0.0"), port);
        socket.listen(5);
        trace('Server listening on http://0.0.0.0:$port');

        while (true) {
            try {
                var client = socket.accept();
                handleClient(client);
            } catch (e:Dynamic) {
                trace('Accept failed: $e');
            }
        }
    }

    private function handleClient(client:Socket) {
        try {
            var request = readRequest(client);
            if (request == null) {
                client.close();
                return;
            }

            var response:HttpResponse;
            if (request.method == "OPTIONS") {
                response = handleOptionsRequest(request);
            } else if (StringTools.startsWith(request.path, "/api/")) {
                response = handleApiRequest(request);
            } else {
                response = handleStaticFileRequest(request);
            }

            writeResponse(client, response);

        } catch (e:Dynamic) {
            trace('Error handling client: $e');
            var errorResponse:HttpResponse = {
                statusCode: 500,
                statusMessage: "Internal Server Error",
                headers: new StringMap(),
                body: Bytes.ofString("Internal Server Error")
            };
            writeResponse(client, errorResponse);
        }
        client.close();
    }

    private function readRequest(client:Socket):HttpRequest {
        var input = client.input;
        var line = input.readLine();
        if (line == null || line == "") return null;

        var parts = line.split(" ");
        if (parts.length < 3) return null;

        var request:HttpRequest = {
            method: parts[0],
            path: parts[1],
            headers: new StringMap(),
            body: ""
        };

        while ((line = input.readLine()) != null && line != "") {
            var headerParts = line.split(":");
            if (headerParts.length > 1) {
                request.headers.set(StringTools.trim(headerParts[0]).toLowerCase(), StringTools.trim(headerParts[1]));
            }
        }

        if (request.headers.exists("content-length")) {
            var len = Std.parseInt(request.headers.get("content-length"));
            if (len > 0) {
                request.body = input.read(len).toString();
            }
        }
        return request;
    }

    private function writeResponse(client:Socket, res:HttpResponse) {
        var output = client.output;
        output.writeString('HTTP/1.1 ${res.statusCode} ${res.statusMessage}\r\n');
        res.headers.set("Connection", "close");
        res.headers.set("Content-Length", '${res.body.length}');
        for (key in res.headers.keys()) {
            output.writeString('$key: ${res.headers.get(key)}\r\n');
        }
        output.writeString('\r\n');
        output.write(res.body);
        output.flush();
    }

    private function handleOptionsRequest(req:HttpRequest):HttpResponse {
        var headers = new StringMap<String>();
        headers.set("Access-Control-Allow-Origin", "*");
        headers.set("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
        headers.set("Access-Control-Allow-Headers", "Content-Type, Authorization");
        return {
            statusCode: 204,
            statusMessage: "No Content",
            headers: headers,
            body: Bytes.ofString("")
        };
    }

    private function handleApiRequest(req:HttpRequest):HttpResponse {
        var headers = new StringMap<String>();
        headers.set("Access-Control-Allow-Origin", "*");
        headers.set("Content-Type", "application/json");

        if (req.path == "/api/chat" && req.method == "POST") {
            var responseBody = callOpenRouter(req.body);
            return {
                statusCode: 200,
                statusMessage: "OK",
                headers: headers,
                body: Bytes.ofString(responseBody)
            };
        }

        return {
            statusCode: 404,
            statusMessage: "Not Found",
            headers: headers,
            body: Bytes.ofString('{"error": "API endpoint not found"}')
        };
    }

    private function handleStaticFileRequest(req:HttpRequest):HttpResponse {
        var wwwRootAbs = Path.normalize(Path.directory(Sys.programPath()) + "/../../" + wwwRoot);
        var filePath = wwwRootAbs + (req.path == "/" ? "/index.html" : req.path);
        trace('Serving static file, checking path: $filePath');
        var headers = new StringMap<String>();

        if (FileSystem.exists(filePath) && !FileSystem.isDirectory(filePath)) {
            trace('File found: $filePath');
            headers.set("Content-Type", getContentType(filePath));
            return {
                statusCode: 200,
                statusMessage: "OK",
                headers: headers,
                body: File.getBytes(filePath)
            };
        }

        trace('File not found: $filePath');
        headers.set("Content-Type", "text/plain");
        return {
            statusCode: 404,
            statusMessage: "Not Found",
            headers: headers,
            body: Bytes.ofString("File not found")
        };
    }

    private function callOpenRouter(requestBody:String):String {
        try {
            var llmRequest:LlmRequest = Json.parse(requestBody);
            var apiKey = Sys.getEnv("OPENROUTER_API_KEY");
            if (apiKey == null || apiKey == "") {
                return Json.stringify({error: "API key not configured"});
            }

            var http = new sys.Http("https://openrouter.ai/api/v1/chat/completions");
            http.setHeader("Authorization", "Bearer " + apiKey);
            http.setHeader("Content-Type", "application/json");

            var data = {
                "model": llmRequest.model,
                "messages": [{"role": "user", "content": llmRequest.message}]
            };
            http.setPostData(Json.stringify(data));

            var responseData = null;
            http.onData = (data) -> responseData = data;
            http.onError = (error) -> throw "OpenRouter API call failed: " + error;
            http.request(true); // Synchronous request

            var openRouterResponse = Json.parse(responseData);
            var llmResponse:LlmResponse = {
                response: openRouterResponse.choices[0].message.content,
                model: openRouterResponse.model
            };
            return Json.stringify(llmResponse);

        } catch (e:Dynamic) {
            return Json.stringify({error: "Internal server error: " + Std.string(e)});
        }
    }

    private function getContentType(filePath:String):String {
        return switch (Path.extension(filePath).toLowerCase()) {
            case "html": "text/html";
            case "css": "text/css";
            case "js": "application/javascript";
            case "png": "image/png";
            case "jpg" | "jpeg": "image/jpeg";
            default: "text/plain";
        }
    }
}

typedef HttpRequest = {
    var method:String;
    var path:String;
    var headers:StringMap<String>;
    var body:String;
}

typedef HttpResponse = {
    var statusCode:Int;
    var statusMessage:String;
    var headers:StringMap<String>;
    var body:Bytes;
}

typedef LlmRequest = {
    var message:String;
    var model:String;
}

typedef LlmResponse = {
    var response:String;
    var model:String;
}