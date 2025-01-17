local PLUGIN_NAME = "custom-response"
local helpers = require "spec.helpers"

describe(PLUGIN_NAME .. ": (handler)", function()
  local client

  setup(function()
    local bp = helpers.get_db_utils(nil, {
      "plugins",
    }, { PLUGIN_NAME })

    bp.plugins:insert {
      name = PLUGIN_NAME,
      config = {
        sensitive_headers = { "Authorization", "X-Api-Key" },
        replacement_text = "[MASKED]",
      },
    }

    assert(helpers.start_kong {
      plugins = "bundled," .. PLUGIN_NAME,
    })
  end)

  teardown(function()
    helpers.stop_kong()
  end)

  before_each(function()
    client = helpers.proxy_client()
  end)

  after_each(function()
    if client then
      client:close()
    end
  end)

  it("masks sensitive headers in the response", function()
    local res = assert(client:send {
      method = "GET",
      path = "/request",
      headers = {
        host = "test.com",
        Authorization = "Bearer secret-token",
        ["X-Api-Key"] = "api-key",
      },
    })

    assert.response(res).has.status(200)
    assert.not_nil(res.headers)
    assert.are.equal("[MASKED]", res.headers["Authorization"])
    assert.are.equal("[MASKED]", res.headers["X-Api-Key"])
  end)
end)
