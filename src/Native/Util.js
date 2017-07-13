var _yjpark$elm_yjpark_util$Native_YJPark_Util = function() {

function now_time() {
  return Date.now();
}

function strict_equal(a, b) {
  return a === b;
}

var logId = 0;
var logPrefix = "]================================================================\n";

function log1(a) {
  console.log("[" + (logId++) + logPrefix, a);
}

function log2(a, b) {
  console.log("[" + (logId++) + logPrefix, a, b);
}

function log3(a, b, c) {
  console.log("[" + (logId++) + logPrefix, a, b, c);
}

function log4(a, b, c, d) {
  console.log("[" + (logId++) + logPrefix, a, b, c, d);
}

function log5(a, b, c, d, e) {
  console.log("[" + (logId++) + logPrefix, a, b, c, d, e);
}

function log6(a, b, c, d, e, f) {
  console.log("[" + (logId++) + logPrefix, a, b, c, d, e, f);
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

return {
  now_time: now_time,
  strict_equal: F2(strict_equal),
  log1: log1,
  log2: F2(log2),
  log3: F3(log3),
  log4: F4(log4),
  log5: F5(log5),
  log6: F6(log6),
  error1: error1,
  error2: F2(error2),
  error3: F3(error3),
  error4: F4(error4),
  error5: F5(error5),
  error6: F6(error6)
};

}();

