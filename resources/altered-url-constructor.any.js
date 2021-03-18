// META: timeout=long

function bURL(url, base) {
  return new URL(url, base || "about:blank")
}

function runURLTests(urltests) {
  for(var i = 0, l = urltests.length; i < l; i++) {
    var expected = urltests[i]
    if (typeof expected === "string") continue // skip comments
    if (expected.failure) continue // don't run tests that should fail
    if (expected.username != "" || expected.password != "") continue // don't run tests that contain userinfo
    
    //skip tests containing userinfo delimiters in the right place but no userinfo
    // this is not a general solution for these types of URLs
    // the reason this is sufficient for now (March 2021) is that in the (at this point) remaining test cases  no @ symbol on the path is removed by normalization
    // a better solution would be to check the characters between protocol and host but this requires handling host, input, and base normalization
    if ((expected.input + expected.base).includes("@") && !expected.path.includes("@")) continue 


    test(function() {
      

      var url = bURL(expected.input, expected.base)
      assert_equals(url.href, expected.href, "href")
      assert_equals(url.protocol, expected.protocol, "protocol")
      assert_equals(url.username, expected.username, "username")
      assert_equals(url.password, expected.password, "password")
      assert_equals(url.host, expected.host, "host")
      assert_equals(url.hostname, expected.hostname, "hostname")
      assert_equals(url.port, expected.port, "port")
      assert_equals(url.pathname, expected.pathname, "pathname")
      assert_equals(url.search, expected.search, "search")
      if ("searchParams" in expected) {
        assert_true("searchParams" in url)
        assert_equals(url.searchParams.toString(), expected.searchParams, "searchParams")
      }
      assert_equals(url.hash, expected.hash, "hash")
    }, "Parsing: <" + expected.input + "> against <" + expected.base + ">")
  }
}

promise_test(() => fetch("resources/urltestdata.json").then(res => res.json()).then(runURLTests), "Loading data…");