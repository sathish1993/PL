#!/usr/bin/env node

"use strict";

//Called with a message and an array of 0-arity functions.  Outputs message
//and calls functions
function run(msg, fns) { //@run_begin@
  console.log(msg)
  for (let i = 0; i < fns.length; i++) {
    fns[i].call();
  }
}
//@run_end@

//Returns an array of function-closures which log a loop-var to console.
//The loop-var is declared using var and hence hoisted to
//function-scope; hence the return'd function-closures refer
//to the final value of the loop var.
function use_var(n) { //@use_var_begin@
  var ret = new Array();
  for (var i = 0; i < n; i++) {
    ret.push(function() { console.log("i = " + i); });
  }
  return ret;
}
//@use_var_end@

//Returns an array of function-closures which log a loop-var to console.
//The loop-var is declared using let and hence each loop
//iteration gets a new copy; hence the return'd function-closures capture
//the current iteration value of the loop var.
function use_let(n) { //@use_let_begin@
  let ret = new Array();
  for (let i = 0; i < n; i++) {
    ret.push(function() { console.log("i = " + i); });
  }
  return ret;
}
//@use_let_end@


const N = 5; //@main_begin@

run("using var", use_var(N));

run("using let", use_let(N));
