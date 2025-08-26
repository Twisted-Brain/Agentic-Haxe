import massive.munit.TestRunner;
import massive.munit.client.RichPrintClient;
import tests.e2e.E2ETest;

class TestMain {
    public static function main() {
        var client = new RichPrintClient();
        var runner = new TestRunner(client);
        runner.run([TestConversation, E2ETest]);
    }
}