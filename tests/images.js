QUnit.module("images");

QUnit.test("we can reference images by name if we specify their dimensions using the \"images\" option", function(assert) {
  var result = Viz("digraph { a[image=\"test.png\"]; }", { images: [ { href: "test.png", width: 400, height: 300 } ] });

  console.log(result);

  var element = document.createElement("div");
  element.innerHTML = result;
  
  assert.equal(element.querySelector("image").getAttributeNS("http://www.w3.org/1999/xlink", "href"), "test.png");
  assert.equal(element.querySelector("image").getAttribute("width"), "400px");
  assert.equal(element.querySelector("image").getAttribute("height"), "300px");
});

QUnit.test("we can reference images with a protocol and hostname", function(assert) {
  var result = Viz("digraph { a[image=\"http://example.com/test.png\"]; }", { images: [ { href: "http://example.com/test.png", width: 400, height: 300 } ] });

  var element = document.createElement("div");
  element.innerHTML = result;
  
  assert.equal(element.querySelector("image").getAttributeNS("http://www.w3.org/1999/xlink", "href"), "http://example.com/test.png");
  assert.equal(element.querySelector("image").getAttribute("width"), "400px");
  assert.equal(element.querySelector("image").getAttribute("height"), "300px");
});
