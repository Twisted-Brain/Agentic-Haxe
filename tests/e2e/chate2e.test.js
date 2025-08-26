const puppeteer = require('puppeteer');
const assert = require('assert');

(async () => {
    const browser = await puppeteer.launch({ headless: true });
    const page = await browser.newPage();
    await page.goto('http://localhost:8080');

    await page.waitForSelector('#chat-input');
    await page.type('#chat-input', 'Hello from E2E test');
    await page.click('#send-button');

    await page.waitForSelector('.message.assistant');
    const botResponse = await page.evaluate(() => {
        const botMessages = document.querySelectorAll('.message.assistant p');
        return botMessages[botMessages.length - 1].textContent;
    });

    console.log(`Bot response: ${botResponse}`);
    assert.ok(botResponse.length > 0, 'Bot should have responded.');

    await browser.close();
    console.log('E2E test passed!');
})().catch(err => {
    console.error('E2E test failed:', err);
    process.exit(1);
});