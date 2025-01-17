package = "kong-plugin-custom-response"
version = "1.0.0-1"
rockspec_format = "1.0"
source = {
  url = "git://your-repo-url.git",
}
description = {
  summary = "Kong plugin to mask sensitive response headers.",
  detailed = "This plugin hides or masks sensitive headers in HTTP responses.",
  homepage = "https://your-homepage.com",
  license = "MIT",
}
dependencies = {
  "lua >= 5.1",
  "kong >= 3.0.0",
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.custom-response.handler"] = "handler.lua",
    ["kong.plugins.custom-response.schema"] = "schema.lua",
  },
}
