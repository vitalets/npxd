const assert = require('assert');
const fetch = require('node-fetch');

/* global it */

it('should add numbers', async () => {
  const response = await fetch('http://localhost:3000');
  const text = await response.text();

  assert.ok(response.ok);
  assert.strictEqual(text, 'Hello World');
});
