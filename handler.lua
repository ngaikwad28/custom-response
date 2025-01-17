local kong = kong

local CustomResponsePlugin = {}

-- Constructor
function CustomResponsePlugin:new()
  local obj = {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end

-- Header filter phase to hide response headers
function CustomResponsePlugin:header_filter(conf)
  -- Loop through headers to identify and mask sensitive ones
  for _, header in ipairs(conf.sensitive_headers) do
    if kong.response.get_header(header) then
      kong.response.set_header(header, conf.replacement_text)
    end
  end
end

-- Define the plugin priority and version
CustomResponsePlugin.PRIORITY = 10
CustomResponsePlugin.VERSION = "1.0.0"

return CustomResponsePlugin
