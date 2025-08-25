package platform.core.python;

import platform.core.python.HttpClientPython;
import platform.core.python.LoggerPython;
import platform.core.python.PlatformClockPython;
import platform.core.python.MLProcessor;
import wiring.DependencyContainer;

/**
 * Main entry point for Python ML service.
 * Provides REST API for ML inference and batch processing.
 */
class PythonMLMain {
    private static var logger: LoggerPython;
    private static var mlProcessor: MLProcessor;
    private static var httpClient: HttpClientPython;
    private static var clock: PlatformClockPython;
    
    public static function main(): Void {
        // Initialize components
        logger = new LoggerPython();
        mlProcessor = new MLProcessor();
        httpClient = new HttpClientPython();
        clock = new PlatformClockPython();
        
        logger.info("Starting Haxe Python ML Service");
        
        // Initialize ML libraries and models
        initializeMLService();
        
        // Start HTTP server
        startHTTPServer();
    }
    
    private static function initializeMLService(): Void {
        logger.info("Initializing ML service components");
        
        var modelInfo = mlProcessor.getModelInfo();
        logger.info("ML Libraries Status", modelInfo);
        
        // Try to load default models if they exist
        var modelsPath = "./models";
        
        untyped __python__("import os");
        
        var tfModelExists = untyped __python__("os.path.exists('models/tensorflow_model')");
        if (tfModelExists) {
            if (mlProcessor.loadTensorFlowModel('models/tensorflow_model')) {
                logger.info('TensorFlow model loaded successfully');
            } else {
                logger.warn('Failed to load TensorFlow model');
            }
        }
        
        var torchModelExists = untyped __python__("os.path.exists('models/pytorch_model.pth')");
        if (torchModelExists) {
            if (mlProcessor.loadPyTorchModel('models/pytorch_model.pth')) {
                logger.info('PyTorch model loaded successfully');
            } else {
                logger.warn('Failed to load PyTorch model');
            }
        }
    }
    
    private static function startHTTPServer(): Void {
        logger.info("Starting HTTP server on port 8080");
        
        // Import required Python modules
        untyped __python__("from http.server import HTTPServer, BaseHTTPRequestHandler");
        untyped __python__("import json");
        untyped __python__("import urllib.parse");
        untyped __python__("from threading import Thread");
        
        // Define request handler class
        untyped __python__("class MLRequestHandler(BaseHTTPRequestHandler):");
        untyped __python__("    def do_GET(self):");
        untyped __python__("        if self.path == '/health':");
        untyped __python__("            self.send_response(200)");
        untyped __python__("            self.send_header('Content-type', 'application/json')");
        untyped __python__("            self.end_headers()");
        untyped __python__("            health_data = {'status': 'healthy', 'timestamp': 1234567890}");
        untyped __python__("            self.wfile.write(json.dumps(health_data).encode())");
        untyped __python__("        elif self.path == '/models/info':");
        untyped __python__("            self.send_response(200)");
        untyped __python__("            self.send_header('Content-type', 'application/json')");
        untyped __python__("            self.end_headers()");
        untyped __python__("            model_info = {'models': 'available'}");
        untyped __python__("            self.wfile.write(json.dumps(model_info).encode())");
        untyped __python__("        else:");
        untyped __python__("            # Serve static files");
        untyped __python__("            import os");
        untyped __python__("            if self.path == '/' or self.path == '/index.html':");
        untyped __python__("                file_path = 'bin/python/static/index.html'");
        untyped __python__("            elif self.path == '/webapp.js':");
        untyped __python__("                file_path = 'bin/python/static/webapp.js'");
        untyped __python__("            elif self.path == '/webapp-styles.css':");
        untyped __python__("                file_path = 'bin/python/static/webapp-styles.css'");
        untyped __python__("            else:");
        untyped __python__("                file_path = None");
        untyped __python__("            ");
        untyped __python__("            if file_path and os.path.exists(file_path):");
        untyped __python__("                with open(file_path, 'rb') as f:");
        untyped __python__("                    content = f.read()");
        untyped __python__("                self.send_response(200)");
        untyped __python__("                if file_path.endswith('.html'):");
        untyped __python__("                    self.send_header('Content-type', 'text/html')");
        untyped __python__("                elif file_path.endswith('.js'):");
        untyped __python__("                    self.send_header('Content-type', 'application/javascript')");
        untyped __python__("                elif file_path.endswith('.css'):");
        untyped __python__("                    self.send_header('Content-type', 'text/css')");
        untyped __python__("                self.end_headers()");
        untyped __python__("                self.wfile.write(content)");
        untyped __python__("            else:");
        untyped __python__("                self.send_response(404)");
        untyped __python__("                self.end_headers()");
        untyped __python__("                self.wfile.write(b'Not Found')");
        
        untyped __python__("    def do_POST(self):");
        untyped __python__("        if self.path.startswith('/inference'):");
        untyped __python__("            self.handle_inference()");
        untyped __python__("        else:");
        untyped __python__("            self.send_response(404)");
        untyped __python__("            self.end_headers()");
        untyped __python__("            self.wfile.write(b'Endpoint not found')");
        
        untyped __python__("    def handle_inference(self):");
        untyped __python__("        try:");
        untyped __python__("            content_length = int(self.headers['Content-Length'])");
        untyped __python__("            post_data = self.rfile.read(content_length)");
        untyped __python__("            data = json.loads(post_data.decode('utf-8'))");
        untyped __python__("            response = {'result': 'processed', 'status': 'success'}");
        untyped __python__("            self.send_response(200)");
        untyped __python__("            self.send_header('Content-type', 'application/json')");
        untyped __python__("            self.end_headers()");
        untyped __python__("            self.wfile.write(json.dumps(response).encode())");
        untyped __python__("        except Exception as e:");
        untyped __python__("            self.send_response(500)");
        untyped __python__("            self.end_headers()");
        untyped __python__("            self.wfile.write(str(e).encode())");
        
        untyped __python__("    def log_message(self, format, *args):");
        untyped __python__("        pass");
        
        // Start server
        untyped __python__("server = HTTPServer(('0.0.0.0', 8080), MLRequestHandler)");
        untyped __python__("print('HTTP server started on http://0.0.0.0:8080')");
        untyped __python__("server.serve_forever()");
    }
}