// Internal browser check. Run against a locally served HTML-renderer web build.
// Set PLAYWRIGHT_MODULE and HERREGA_CHROMIUM if they are outside default paths.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {chromium} = require(process.env.PLAYWRIGHT_MODULE || 'playwright');
const baseUrl = process.env.HERREGA_BROWSER_URL || 'http://127.0.0.1:8765/';
const output = process.env.HERREGA_BROWSER_OUTPUT || '/tmp/herrega-browser-check';
// The recommendation starts at 1 + 1; its separate transfer is 2 + 1.
const firstLesson = 'numberLine-007';

async function enableSemantics(page) {
  const placeholder = page.getByRole('button', {name: 'Enable accessibility', exact: true});
  await placeholder.waitFor();
  // Flutter puts its accessibility placeholder outside the viewport. This
  // only enables semantics; every learner action below uses normal input.
  await placeholder.evaluate(node => node.click());
  await page.getByRole('button', {name: 'Jalqabi', exact: true}).waitFor();
}

async function run() {
  fs.mkdirSync(output, {recursive: true});
  const browser = await chromium.launch({
    executablePath: process.env.HERREGA_CHROMIUM || undefined,
    headless: true,
    args: ['--no-sandbox'],
  });
  const report = [];
  try {
    for (const width of [320, 390]) {
      const context = await browser.newContext({viewport: {width, height: 844}, deviceScaleFactor: 1});
      const page = await context.newPage();
      page.setDefaultTimeout(15000);
      const external = [], errors = [], onlineFailures = [];
      let offline = false;
      page.on('request', request => {
        if (!request.url().startsWith(baseUrl) && !request.url().startsWith('data:')) {
          external.push(request.url());
        }
      });
      page.on('pageerror', error => errors.push(String(error)));
      page.on('requestfailed', request => {
        if (!offline) onlineFailures.push({url: request.url(), error: request.failure()});
      });
      await page.goto(baseUrl, {waitUntil: 'networkidle'});
      await enableSemantics(page);
      await page.screenshot({path: path.join(output, `home-${width}.png`)});
      await page.getByRole('button', {name: 'Jalqabi', exact: true}).click();
      const next = page.getByRole('button', {name: 'Itti fufi', exact: true});
      assert.equal(await next.isEnabled(), false, 'A construction must be completed first.');
      assert.ok(await page.locator('[aria-label*="Akkaataa taphachuu"]').count(), 'Instructions must be visible by default.');
      await page.getByRole('button', {name: 'Taphadhu', exact: true}).click();
      await page.getByRole('button', {name: '+1', exact: true}).click();
      await next.click();
      await page.getByRole('button', {name: 'Yaali', exact: true}).click();
      const input = page.getByRole('textbox');
      // Flutter merges the panel's label into the textbox semantics bounds.
      // Its centre is the formula; the editor occupies the lower quarter.
      let box = await input.boundingBox();
      await input.click({force: true, position: {x: box.width / 2, y: box.height * .75}});
      await page.locator('input[autocorrect="on"]').waitFor();
      await page.keyboard.type('7');
      await page.getByRole('button', {name: 'Mirkaneessi', exact: true}).click();
      await input.waitFor();
      let progress = await page.evaluate(() => JSON.parse(localStorage.getItem('herrega.progress.v1')));
      assert.equal(progress.entries[firstLesson].independent, false, 'A wrong transfer cannot earn a star.');
      assert.equal(progress.entries[firstLesson].attempts, 1, 'The typed wrong answer must reach the controller.');
      box = await input.boundingBox();
      await input.click({force: true, position: {x: box.width / 2, y: box.height * .75}});
      await page.locator('input[autocorrect="on"]').waitFor();
      await page.keyboard.press('Control+A');
      await page.keyboard.type('3');
      await page.screenshot({path: path.join(output, `transfer-${width}.png`)});
      await page.getByRole('button', {name: 'Mirkaneessi', exact: true}).click();
      await page.getByRole('button', {name: 'Deebi’i', exact: true}).waitFor();
      progress = await page.evaluate(() => JSON.parse(localStorage.getItem('herrega.progress.v1')));
      assert.deepEqual(progress.entries[firstLesson], {
        construction: true, independent: true, assisted: false, attempts: 2,
      });
      await page.screenshot({path: path.join(output, `completion-${width}.png`)});
      await page.getByRole('button', {name: 'Deebi’i', exact: true}).click();
      await page.evaluate(async () => { await navigator.serviceWorker.ready; });
      // Warm the loader resources under service-worker control before testing
      // browser reload. Android uses bundled assets and needs no warm-up.
      await page.reload({waitUntil: 'networkidle'});
      await enableSemantics(page);
      await page.waitForFunction(() => navigator.serviceWorker.controller !== null);
      const caches = await page.evaluate(async () => ({
        controller: navigator.serviceWorker.controller.scriptURL,
        resources: (await (await window.caches.open('flutter-app-cache')).keys()).map(r => r.url),
      }));
      offline = true;
      await context.setOffline(true);
      await page.reload({waitUntil: 'load'});
      await enableSemantics(page);
      const restored = await page.evaluate(() => JSON.parse(localStorage.getItem('herrega.progress.v1')));
      assert.deepEqual(restored, progress, 'Offline reload must retain the complete progress record.');
      await page.getByRole('button', {name: 'Jalqabi', exact: true}).click();
      await page.getByRole('button', {name: 'Taphadhu', exact: true}).click();
      await page.getByRole('button', {name: '+1', exact: true}).click();
      await page.getByRole('button', {name: 'Back', exact: true}).click();
      await page.screenshot({path: path.join(output, `offline-${width}.png`)});
      assert.deepEqual(external, [], 'Learner play must make no external request.');
      assert.deepEqual(errors, [], 'The app must not throw browser exceptions.');
      assert.deepEqual(onlineFailures, [], 'Online startup must not contain failed asset requests.');
      report.push({width, completedLesson: firstLesson, wrongAnswerRejected: true,
        transferAttempts: 2, progressRestoredOffline: true, nextLessonInteractiveOffline: true,
        externalRequests: external.length, browserErrors: errors.length, caches});
      await context.close();
    }
    fs.writeFileSync(path.join(output, 'report.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify({passed: true, widths: report.map(r => r.width), report: path.join(output, 'report.json')}));
  } finally {
    await browser.close();
  }
}

run().catch(error => { console.error(error); process.exitCode = 1; });
