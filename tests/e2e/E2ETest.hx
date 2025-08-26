package tests.e2e;

import massive.munit.TestSuite;
import massive.munit.Assert;
import tests.e2e.Puppeteer;

class E2ETest extends TestSuite {

    @Test
    @:asyncTest
    public function testHomePageLoads(done:Void->Void):Void {
        Puppeteer.launch().then(function(browser) {
            browser.newPage().then(function(page) {
                page.goto("http://localhost:8080").then(function(_) {
                    page.content().then(function(content) {
                        Assert.isTrue(content.indexOf("Haxe AI Chat") > -1, "Expected to find 'Haxe AI Chat' on the page");
                        browser.close().then(function(_) {
                            done();
                        });
                    });
                });
            });
        });
    }
}