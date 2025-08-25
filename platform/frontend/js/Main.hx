import react.ReactComponent;
import react.ReactMacro.jsx;
import react.ReactDOM;
import js.Browser;
import platform.frontend.js.components.ChatView;

class Main {
    static function main() {
        final container = ReactDOM.createRoot(Browser.document.getElementById("app"));
        container.render(jsx('<${ChatView} />'));
    }
}