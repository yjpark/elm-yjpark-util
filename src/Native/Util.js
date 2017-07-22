var _yjpark$elm_yjpark_util$Native_Util = function() {

function now_time() {
  return Date.now();
}

function strict_equal(a, b) {
  return a === b;
}

var logId = 0;
var logPrefix = "]================================================================\n";

function info1(a) {
  console.info("[" + (logId++) + logPrefix, a);
}

function info2(a, b) {
  console.info("[" + (logId++) + logPrefix, a, b);
}

function info3(a, b, c) {
  console.info("[" + (logId++) + logPrefix, a, b, c);
}

function info4(a, b, c, d) {
  console.info("[" + (logId++) + logPrefix, a, b, c, d);
}

function info5(a, b, c, d, e) {
  console.info("[" + (logId++) + logPrefix, a, b, c, d, e);
}

function info6(a, b, c, d, e, f) {
  console.info("[" + (logId++) + logPrefix, a, b, c, d, e, f);
}

function error1(a) {
  console.error("[" + (logId++) + logPrefix, a);
}

function error2(a, b) {
  console.error("[" + (logId++) + logPrefix, a, b);
}

function error3(a, b, c) {
  console.error("[" + (logId++) + logPrefix, a, b, c);
}

function error4(a, b, c, d) {
  console.error("[" + (logId++) + logPrefix, a, b, c, d);
}

function error5(a, b, c, d, e) {
  console.error("[" + (logId++) + logPrefix, a, b, c, d, e);
}

function error6(a, b, c, d, e, f) {
  console.error("[" + (logId++) + logPrefix, a, b, c, d, e, f);
}

function debug1(a) {
  console.debug("[" + (logId++) + logPrefix, a);
}

function debug2(a, b) {
  console.debug("[" + (logId++) + logPrefix, a, b);
}

function debug3(a, b, c) {
  console.debug("[" + (logId++) + logPrefix, a, b, c);
}

function debug4(a, b, c, d) {
  console.debug("[" + (logId++) + logPrefix, a, b, c, d);
}

function debug5(a, b, c, d, e) {
  console.debug("[" + (logId++) + logPrefix, a, b, c, d, e);
}

function debug6(a, b, c, d, e, f) {
  console.debug("[" + (logId++) + logPrefix, a, b, c, d, e, f);
}

return {
  now_time: now_time,
  strict_equal: F2(strict_equal),
  info1: info1,
  info2: F2(info2),
  info3: F3(info3),
  info4: F4(info4),
  info5: F5(info5),
  info6: F6(info6),
  error1: error1,
  error2: F2(error2),
  error3: F3(error3),
  error4: F4(error4),
  error5: F5(error5),
  error6: F6(error6),
  debug1: debug1,
  debug2: F2(debug2),
  debug3: F3(debug3),
  debug4: F4(debug4),
  debug5: F5(debug5),
  debug6: F6(debug6)
};

}();

