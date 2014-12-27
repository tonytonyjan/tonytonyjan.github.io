#include <ruby.h>

VALUE rb_cFoo;

VALUE initialize(VALUE self){
  printf("foo\n");
  return self;
}

int Init_foo(int argc, char const *argv[]){
  rb_cFoo = rb_define_class("Foo", rb_cObject);
  rb_define_method(rb_cFoo, "initialize", initialize, 0);
  return 0;
}