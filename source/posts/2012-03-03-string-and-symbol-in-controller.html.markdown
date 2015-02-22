---
title: "params[\"key\"] 和 params[:key]"
date: 2012-03-03 15:31 +0800
category: 程式
tags: Ruby, Ruby on Rails
---

今天在寫學長託付的 API Server 時，突然對 controller 中用到的 params 變數感到好奇，我想知道為什麼 `params[:id]` 和 `params["id"]` 都可以 access 同一份資料，於是展開了 trace code 奇幻之旅。

我臨時寫了一個程式，先 trace `params[:id]`，再 trace `params["id"]`，並用等於符號分隔，看他們之間的不同：

``` ruby Experiment in controller
set_trace_func proc { |event, file, line, id, binding, classname|
   printf "%8s %s:%-2d %10s %8s\n", event, file, line, id, classname
}
params[:id]
set_trace_func nil

puts "=====================" # 我不希望 trace 到 puts method

set_trace_func proc { |event, file, line, id, binding, classname|
   printf "%8s %s:%-2d %10s %8s\n", event, file, line, id, classname
}
params["id"]
set_trace_func nil
```
<!-- more -->

我本來以為使用 Symbol 替代 String 是比較省力的，想不到 Rails 下當我們呼叫 `params[:key]` 時，會徒增許多 call stack，事實就是，Rails 還得幫我們把 Symbol 轉成 String。

``` text Difference between using Symbol and String
c-return D:/TonySpace/workspace/monster-fighter/app/controllers/api_controller.rb:61 set_trace_func   Kernel
    line D:/TonySpace/workspace/monster-fighter/app/controllers/api_controller.rb:62 UpdatePlayerInfo ApiController
    call C:/Ruby193/lib/ruby/gems/1.9.1/gems/actionpack-3.2.2/lib/action_controller/metal.rb:143     params ActionController::Metal
    line C:/Ruby193/lib/ruby/gems/1.9.1/gems/actionpack-3.2.2/lib/action_controller/metal.rb:144     params ActionController::Metal
    call C:/Ruby193/lib/ruby/gems/1.9.1/gems/actionpack-3.2.2/lib/action_dispatch/http/parameters.rb:8  parameters ActionDispatch::Http::Parameters
    line C:/Ruby193/lib/ruby/gems/1.9.1/gems/actionpack-3.2.2/lib/action_dispatch/http/parameters.rb:9  parameters ActionDispatch::Http::Parameters
  return C:/Ruby193/lib/ruby/gems/1.9.1/gems/actionpack-3.2.2/lib/action_dispatch/http/parameters.rb:14 parameters ActionDispatch::Http::Parameters
  return C:/Ruby193/lib/ruby/gems/1.9.1/gems/actionpack-3.2.2/lib/action_controller/metal.rb:145     params ActionController::Metal
  c-call D:/TonySpace/workspace/monster-fighter/app/controllers/api_controller.rb:62         []     Hash
    call C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:32    default ActiveSupport::HashWithIndifferentAccess
    line C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:33    default ActiveSupport::HashWithIndifferentAccess
  c-call C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:33      is_a?   Kernel
c-return C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:33      is_a?   Kernel
  c-call C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:33       to_s   Symbol
c-return C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:33       to_s   Symbol
    call C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:88       key? ActiveSupport::HashWithIndifferentAccess
    line C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:89       key? ActiveSupport::HashWithIndifferentAccess
    call C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:152 convert_key ActiveSupport::HashWithIndifferentAccess
    line C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:153 convert_key ActiveSupport::HashWithIndifferentAccess
  c-call C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:153   kind_of?   Kernel
c-return C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:153   kind_of?   Kernel
    line C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:153 convert_key ActiveSupport::HashWithIndifferentAccess
  return C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:154 convert_key ActiveSupport::HashWithIndifferentAccess
  c-call C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:89       key?     Hash
c-return C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:89       key?     Hash
  return C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:90       key? ActiveSupport::HashWithIndifferentAccess
    line C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:36    default ActiveSupport::HashWithIndifferentAccess
  c-call C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:36    default     Hash
c-return C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:36    default     Hash
  return C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:38    default ActiveSupport::HashWithIndifferentAccess
c-return D:/TonySpace/workspace/monster-fighter/app/controllers/api_controller.rb:62         []     Hash
    line D:/TonySpace/workspace/monster-fighter/app/controllers/api_controller.rb:63 UpdatePlayerInfo ApiController
  c-call D:/TonySpace/workspace/monster-fighter/app/controllers/api_controller.rb:63 set_trace_func   Kernel
=====================
c-return D:/TonySpace/workspace/monster-fighter/app/controllers/api_controller.rb:67 set_trace_func   Kernel
    line D:/TonySpace/workspace/monster-fighter/app/controllers/api_controller.rb:68 UpdatePlayerInfo ApiController
    call C:/Ruby193/lib/ruby/gems/1.9.1/gems/actionpack-3.2.2/lib/action_controller/metal.rb:143     params ActionController::Metal
    line C:/Ruby193/lib/ruby/gems/1.9.1/gems/actionpack-3.2.2/lib/action_controller/metal.rb:144     params ActionController::Metal
  return C:/Ruby193/lib/ruby/gems/1.9.1/gems/actionpack-3.2.2/lib/action_controller/metal.rb:145     params ActionController::Metal
  c-call D:/TonySpace/workspace/monster-fighter/app/controllers/api_controller.rb:68         []     Hash
    call C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:32    default ActiveSupport::HashWithIndifferentAccess
    line C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:33    default ActiveSupport::HashWithIndifferentAccess
  c-call C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:33      is_a?   Kernel
c-return C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:33      is_a?   Kernel
    line C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:36    default ActiveSupport::HashWithIndifferentAccess
  c-call C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:36    default     Hash
c-return C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:36    default     Hash
  return C:/Ruby193/lib/ruby/gems/1.9.1/gems/activesupport-3.2.2/lib/active_support/hash_with_indifferent_access.rb:38    default ActiveSupport::HashWithIndifferentAccess
c-return D:/TonySpace/workspace/monster-fighter/app/controllers/api_controller.rb:68         []     Hash
    line D:/TonySpace/workspace/monster-fighter/app/controllers/api_controller.rb:69 UpdatePlayerInfo ApiController
  c-call D:/TonySpace/workspace/monster-fighter/app/controllers/api_controller.rb:69 set_trace_func   Kernel
```

以往知道 Symbol 適合拿來當 key，是因為你不管 access 幾次，都是指到同一個 memory，而且不會被 GC 回收。舉例來說，如果我們存取 `params["id"]` 一百次，則會產生一百個 `"id"` 字串，反觀使用 Symbol 則不會花太多時間和資源在建立物件上：

``` ruby Experiment code
100.times{
  printf "%d\t%d", "tonytonyjan".object_id, :tonytonyjan.object_id
}
```