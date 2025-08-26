package;

import massive.munit.TestSuite;
import massive.munit.Assert;
import domain.core.Conversation;

class TestConversation extends TestSuite {
    public function new() {
        super();
    }

    @Test
    public function testInitialState() {
        var conversation = new Conversation("test_id", "test_title", "test_model");
        Assert.areEqual(0, conversation.messages.length);
    }
}