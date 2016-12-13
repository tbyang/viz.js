QUnit.module("lite");

QUnit.test("neato layout should fail for lite version", function(assert) {
  assert.throws(function() { Viz("digraph { a -> b; }", { engine: "neato" }); });
});